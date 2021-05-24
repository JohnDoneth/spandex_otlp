defmodule SpandexOTLP.Sender do
  @moduledoc """
  A worker for sending spans to a OLTP accepting service.

  Uses a GenServer in order to send traces asynchronously.
  """
  use GenServer
  require Logger

  alias Spandex.Trace
  alias SpandexOTLP.Conversion
  alias SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.ExportTraceServiceRequest
  alias SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.TraceService
  alias SpandexOTLP.Opentelemetry.Proto.Trace.V1.ResourceSpans

  defp require_config_for(config, key) do
    if Map.has_key?(config, key) do
      config
    else
      raise "`Missing config: `#{key}` needs to be set!"
    end
  end

  defp default_config do
    %{
      batch: %{
        timeout: {200, :milliseconds},
        send_batch_size: 8192
      }
    }
  end

  defp get_config(opts) do
    app_config =
      case Application.get_env(:spandex_otlp, SpandexOTLP) do
        nil -> %{}
        config -> Enum.into(config, %{})
      end

    config =
      default_config()
      |> Map.merge(app_config)
      |> Map.merge(opts)
      |> require_config_for(:endpoint)

    Map.update(config, :ca_cert_file, nil, fn ca_cert_file ->
      case ca_cert_file do
        nil ->
          nil

        ca_cert_file ->
          config.otp_app
          |> :code.priv_dir()
          |> Path.join(ca_cert_file)
      end
    end)
  end

  defmodule State do
    @moduledoc false
    @type t :: %State{
            channel: any(),
            metadata: map(),
            # Settings for trace batching
            batch: %{
              # Number of traces after which a batch will be sent regardless of the timeout.
              send_batch_size: integer(),
              # Time duration after which a batch will be sent regardless of size.
              timeout: {non_neg_integer(), :milliseconds}
            },
            # Queued spans for sending.
            resource_spans: [ResourceSpan.t()],
            # Last send of spans
            last_send: DateTime.t()
          }

    defstruct [
      :channel,
      :metadata,
      :batch,
      :resource_spans,
      :last_send
    ]
  end

  @doc """
  Starts the GenServer with given options.
  """
  @spec start_link(opts :: Keyword.t()) :: GenServer.on_start()
  def start_link(opts) do
    case GenServer.start_link(__MODULE__, opts, name: __MODULE__) do
      {:ok, s} -> {:ok, s}
      {:error, e} -> {:stop, e}
    end
  end

  @doc false
  @spec init(opts :: Keyword.t()) :: {:ok, State.t()}
  def init(opts) do
    config = get_config(Enum.into(opts, %{}))

    case connect(config) do
      {:ok, channel} ->
        state =
          %State{
            channel: channel,
            metadata: Map.get(config, :headers, %{}),
            batch: config[:batch],
            resource_spans: [],
            last_send: DateTime.utc_now()
          }
          |> schedule_batch_timeout_check()

        {:ok, state}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  defp connect(config) do
    opts =
      case config.ca_cert_file do
        nil -> []
        ca_path -> [cred: GRPC.Credential.new(ssl: [cacertfile: ca_path])]
      end

    case GRPC.Stub.connect(config.endpoint, opts) do
      {:ok, channel} ->
        {:ok, channel}

      {:error, error} ->
        Logger.error("Failed to connect to OTLP endpoint: #{error}")
        {:error, error}
    end
  end

  @doc """
  Send spans asynchronously to the configured endpoint.
  """
  @spec send_trace(Trace.t(), Keyword.t()) :: :ok
  def send_trace(%Trace{} = trace, opts \\ []) do
    :telemetry.span([:spandex_oltp, :send_trace], %{trace: trace}, fn ->
      timeout = Keyword.get(opts, :timeout, 30_000)
      result = GenServer.call(__MODULE__, {:send_trace, trace}, timeout)
      {result, %{trace: trace}}
    end)
  end

  @spec convert_and_enqueue_span(State.t(), Trace.t()) :: State.t()
  defp convert_and_enqueue_span(state, trace) do
    %{
      state
      | resource_spans: Conversion.traces_to_resource_spans([trace]) ++ state.resource_spans
    }
  end

  @spec maybe_send_batch(State.t()) :: State.t()
  defp maybe_send_batch(state) do
    with true <- spans_to_send?(state),
         true <- exceeds_send_batch_size?(state) || elapsed_batch_timeout?(state) do
      send_batch(state)
    else
      false -> state
    end
  end

  @spec exceeds_send_batch_size?(State.t()) :: boolean()
  defp exceeds_send_batch_size?(state) do
    length(state.resource_spans) >= state.batch.send_batch_size
  end

  @spec spans_to_send?(State.t()) :: boolean()
  defp spans_to_send?(state) do
    length(state.resource_spans) > 0
  end

  # Returns a State struct with spans removed and the spans removed in a tuple.
  @spec empty_spans(State.t()) :: {State.t(), [ResourceSpans.t()]}
  defp empty_spans(state) do
    {%{state | resource_spans: []}, state.resource_spans}
  end

  defp send_batch(state) do
    {state, resource_spans} = empty_spans(state)

    request = ExportTraceServiceRequest.new(resource_spans: resource_spans)

    case TraceService.Stub.export(state.channel, request, metadata: state.metadata) do
      {:ok, _response} ->
        :ok

      {:error, error} ->
        Logger.error("Error while exporting trace data: #{inspect(error)}")
    end

    %{state | last_send: DateTime.utc_now()}
  end

  @doc false
  def handle_call({:send_trace, trace}, _from, state) do
    state =
      state
      |> convert_and_enqueue_span(trace)
      |> maybe_send_batch()

    {:reply, :ok, state}
  end

  @doc false
  def handle_info(:timeout_check, state) do
    {:noreply, state |> maybe_send_batch() |> schedule_batch_timeout_check()}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  @spec elapsed_batch_timeout?(State.t()) :: boolean()
  defp elapsed_batch_timeout?(state) do
    now = DateTime.utc_now()
    {timeout_millis, :milliseconds} = state.batch.timeout
    DateTime.diff(now, state.last_send, :millisecond) > timeout_millis
  end

  @spec schedule_batch_timeout_check(State.t()) :: State.t()
  defp schedule_batch_timeout_check(state) do
    {ms, :milliseconds} = state.batch.timeout
    Process.send_after(self(), :timeout_check, ms)
    state
  end
end

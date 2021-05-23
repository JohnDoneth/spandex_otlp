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

  @app_config Application.get_env(:spandex_otlp, SpandexOTLP)

  defp require_config_for(config, key) do
    if Map.has_key?(config, key) do
      config
    else
      raise "`Missing config: `#{key}` needs to be set!"
    end
  end

  defp get_config(opts) do
    app_config =
      case @app_config do
        nil -> %{}
        config -> Enum.into(config, %{})
      end

    config =
      app_config
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
    @type t :: %State{}

    defstruct [
      :channel,
      :metadata
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
        {:ok,
         %State{
           channel: channel,
           metadata: Map.get(config, :headers, %{})
         }}

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

  @doc false
  def handle_call({:send_trace, trace}, _from, state) do
    request =
      ExportTraceServiceRequest.new(resource_spans: Conversion.traces_to_resource_spans([trace]))

    case TraceService.Stub.export(state.channel, request, metadata: state.metadata) do
      {:ok, _response} ->
        :ok

      {:error, error} ->
        Logger.error("Error while exporting trace data: #{inspect(error)}")
    end

    {:reply, :ok, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end

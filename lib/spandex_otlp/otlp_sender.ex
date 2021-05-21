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

  @endpoint Application.compile_env(:spandex_otlp, :endpoint, "localhost:4317")

  defp ca_cert_file do
    case Application.get_env(:spandex_otlp, :ca_cert_file, nil) do
      nil ->
        nil

      ca_cert_file ->
        otp_app()
        |> :code.priv_dir()
        |> Path.join(ca_cert_file)
    end
  end

  defp otp_app do
    case Application.get_env(:spandex_otlp, :otp_app) do
      nil -> raise "otp_app needs to be set!"
      otp_app -> otp_app
    end
  end

  defmodule State do
    @moduledoc false
    @type t :: %State{}

    defstruct [
      :channel
    ]
  end

  @spec start_link :: GenServer.on_start()
  def start_link, do: start_link([])

  @doc """
  Starts the GenServer with given options.
  """
  @spec start_link(opts :: Keyword.t()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc false
  @spec init(opts :: Keyword.t()) :: {:ok, State.t()}
  def init(_opts) do
    {:ok, channel} = connect()

    {:ok,
     %State{
       channel: channel
     }}
  end

  defp connect do
    opts =
      case ca_cert_file() do
        nil -> []
        ca_path -> [cred: GRPC.Credential.new(ssl: [cacertfile: ca_path])]
      end

    case GRPC.Stub.connect(@endpoint, opts) do
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
    headers = Application.get_env(:spandex_otlp, :headers, %{})

    request =
      ExportTraceServiceRequest.new(resource_spans: Conversion.traces_to_resource_spans([trace]))

    case TraceService.Stub.export(state.channel, request, metadata: headers) do
      {:ok, _response} ->
        :ok

      {:error, error} ->
        Logger.error("Failed to send trace data: #{error}")
    end

    {:reply, :ok, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end

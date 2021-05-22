defmodule SpandexOTLP.TestServer do
  @moduledoc false

  use GRPC.Server,
    service: SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.TraceService.Service

  alias SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.ExportTraceServiceResponse

  def export(request, _stream) do
    SpandexOTLP.RequestStore.put_request(request)
    ExportTraceServiceResponse.new()
  end
end

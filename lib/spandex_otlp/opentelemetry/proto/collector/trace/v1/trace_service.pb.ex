defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.ExportTraceServiceRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          resource_spans: [SpandexOTLP.Opentelemetry.Proto.Trace.V1.ResourceSpans.t()]
        }
  defstruct [:resource_spans]

  field(:resource_spans, 1,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.ResourceSpans
  )
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.ExportTraceServiceResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.TraceService.Service do
  @moduledoc false
  use GRPC.Service, name: "opentelemetry.proto.collector.trace.v1.TraceService"

  rpc(
    :Export,
    SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.ExportTraceServiceRequest,
    SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.ExportTraceServiceResponse
  )
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.TraceService.Stub do
  @moduledoc false
  use GRPC.Stub, service: SpandexOTLP.Opentelemetry.Proto.Collector.Trace.V1.TraceService.Service
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Metrics.V1.ExportMetricsServiceRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          resource_metrics: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.ResourceMetrics.t()]
        }
  defstruct [:resource_metrics]

  field(:resource_metrics, 1,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.ResourceMetrics
  )
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Metrics.V1.ExportMetricsServiceResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Metrics.V1.MetricsService.Service do
  @moduledoc false
  use GRPC.Service, name: "opentelemetry.proto.collector.metrics.v1.MetricsService"

  rpc(
    :Export,
    SpandexOTLP.Opentelemetry.Proto.Collector.Metrics.V1.ExportMetricsServiceRequest,
    SpandexOTLP.Opentelemetry.Proto.Collector.Metrics.V1.ExportMetricsServiceResponse
  )
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Metrics.V1.MetricsService.Stub do
  @moduledoc false
  use GRPC.Stub,
    service: SpandexOTLP.Opentelemetry.Proto.Collector.Metrics.V1.MetricsService.Service
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Logs.V1.ExportLogsServiceRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          resource_logs: [SpandexOTLP.Opentelemetry.Proto.Logs.V1.ResourceLogs.t()]
        }
  defstruct [:resource_logs]

  field :resource_logs, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Logs.V1.ResourceLogs
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Logs.V1.ExportLogsServiceResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Logs.V1.LogsService.Service do
  @moduledoc false
  use GRPC.Service, name: "opentelemetry.proto.collector.logs.v1.LogsService"

  rpc :Export,
      SpandexOTLP.Opentelemetry.Proto.Collector.Logs.V1.ExportLogsServiceRequest,
      SpandexOTLP.Opentelemetry.Proto.Collector.Logs.V1.ExportLogsServiceResponse
end

defmodule SpandexOTLP.Opentelemetry.Proto.Collector.Logs.V1.LogsService.Stub do
  @moduledoc false
  use GRPC.Stub, service: SpandexOTLP.Opentelemetry.Proto.Collector.Logs.V1.LogsService.Service
end

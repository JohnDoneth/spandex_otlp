defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          resource: SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource.t() | nil,
          last_known_fingerprint: binary
        }
  defstruct [:resource, :last_known_fingerprint]

  field :resource, 1, type: SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource
  field :last_known_fingerprint, 2, type: :bytes
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse.Schedule.Pattern do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          match: {atom, any}
        }
  defstruct [:match]

  oneof :match, 0

  field :equals, 1, type: :string, oneof: 0
  field :starts_with, 2, type: :string, oneof: 0
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse.Schedule do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          exclusion_patterns: [
            SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse.Schedule.Pattern.t()
          ],
          inclusion_patterns: [
            SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse.Schedule.Pattern.t()
          ],
          period_sec: integer
        }
  defstruct [:exclusion_patterns, :inclusion_patterns, :period_sec]

  field :exclusion_patterns, 1,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse.Schedule.Pattern

  field :inclusion_patterns, 2,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse.Schedule.Pattern

  field :period_sec, 3, type: :int32
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          fingerprint: binary,
          schedules: [SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse.Schedule.t()],
          suggested_wait_time_sec: integer
        }
  defstruct [:fingerprint, :schedules, :suggested_wait_time_sec]

  field :fingerprint, 1, type: :bytes

  field :schedules, 2,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse.Schedule

  field :suggested_wait_time_sec, 3, type: :int32
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfig.Service do
  @moduledoc false
  use GRPC.Service, name: "opentelemetry.proto.metrics.experimental.MetricConfig"

  rpc :GetMetricConfig,
      SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigRequest,
      SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfigResponse
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfig.Stub do
  @moduledoc false
  use GRPC.Stub, service: SpandexOTLP.Opentelemetry.Proto.Metrics.Experimental.MetricConfig.Service
end

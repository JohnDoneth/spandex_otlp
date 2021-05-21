defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.ConstantSampler.ConstantDecision do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :ALWAYS_OFF | :ALWAYS_ON | :ALWAYS_PARENT

  field(:ALWAYS_OFF, 0)
  field(:ALWAYS_ON, 1)
  field(:ALWAYS_PARENT, 2)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.TraceConfig do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          sampler: {atom, any},
          max_number_of_attributes: integer,
          max_number_of_timed_events: integer,
          max_number_of_attributes_per_timed_event: integer,
          max_number_of_links: integer,
          max_number_of_attributes_per_link: integer
        }
  defstruct [
    :sampler,
    :max_number_of_attributes,
    :max_number_of_timed_events,
    :max_number_of_attributes_per_timed_event,
    :max_number_of_links,
    :max_number_of_attributes_per_link
  ]

  oneof(:sampler, 0)

  field(:constant_sampler, 1,
    type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.ConstantSampler,
    oneof: 0
  )

  field(:trace_id_ratio_based, 2,
    type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.TraceIdRatioBased,
    oneof: 0
  )

  field(:rate_limiting_sampler, 3,
    type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.RateLimitingSampler,
    oneof: 0
  )

  field(:max_number_of_attributes, 4, type: :int64)
  field(:max_number_of_timed_events, 5, type: :int64)
  field(:max_number_of_attributes_per_timed_event, 6, type: :int64)
  field(:max_number_of_links, 7, type: :int64)
  field(:max_number_of_attributes_per_link, 8, type: :int64)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.ConstantSampler do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          decision: SpandexOTLP.Opentelemetry.Proto.Trace.V1.ConstantSampler.ConstantDecision.t()
        }
  defstruct [:decision]

  field(:decision, 1,
    type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.ConstantSampler.ConstantDecision,
    enum: true
  )
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.TraceIdRatioBased do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          samplingRatio: float | :infinity | :negative_infinity | :nan
        }
  defstruct [:samplingRatio]

  field(:samplingRatio, 1, type: :double)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.RateLimitingSampler do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          qps: integer
        }
  defstruct [:qps]

  field(:qps, 1, type: :int64)
end

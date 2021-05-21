defmodule SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributes: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()],
          dropped_attributes_count: non_neg_integer
        }
  defstruct [:attributes, :dropped_attributes_count]

  field(:attributes, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue)
  field(:dropped_attributes_count, 2, type: :uint32)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Common.V1.AnyValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any}
        }
  defstruct [:value]

  oneof(:value, 0)

  field(:string_value, 1, type: :string, oneof: 0)
  field(:bool_value, 2, type: :bool, oneof: 0)
  field(:int_value, 3, type: :int64, oneof: 0)
  field(:double_value, 4, type: :double, oneof: 0)
  field(:array_value, 5, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.ArrayValue, oneof: 0)
  field(:kvlist_value, 6, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValueList, oneof: 0)
  field(:bytes_value, 7, type: :bytes, oneof: 0)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Common.V1.ArrayValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          values: [SpandexOTLP.Opentelemetry.Proto.Common.V1.AnyValue.t()]
        }
  defstruct [:values]

  field(:values, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.AnyValue)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValueList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          values: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()]
        }
  defstruct [:values]

  field(:values, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: SpandexOTLP.Opentelemetry.Proto.Common.V1.AnyValue.t() | nil
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.AnyValue)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue do
  @moduledoc false
  use Protobuf, deprecated: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Common.V1.InstrumentationLibrary do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          version: String.t()
        }
  defstruct [:name, :version]

  field(:name, 1, type: :string)
  field(:version, 2, type: :string)
end

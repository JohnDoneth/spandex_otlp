defmodule SpandexOTLP.Opentelemetry.Proto.Logs.V1.SeverityNumber do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :SEVERITY_NUMBER_UNSPECIFIED
          | :SEVERITY_NUMBER_TRACE
          | :SEVERITY_NUMBER_TRACE2
          | :SEVERITY_NUMBER_TRACE3
          | :SEVERITY_NUMBER_TRACE4
          | :SEVERITY_NUMBER_DEBUG
          | :SEVERITY_NUMBER_DEBUG2
          | :SEVERITY_NUMBER_DEBUG3
          | :SEVERITY_NUMBER_DEBUG4
          | :SEVERITY_NUMBER_INFO
          | :SEVERITY_NUMBER_INFO2
          | :SEVERITY_NUMBER_INFO3
          | :SEVERITY_NUMBER_INFO4
          | :SEVERITY_NUMBER_WARN
          | :SEVERITY_NUMBER_WARN2
          | :SEVERITY_NUMBER_WARN3
          | :SEVERITY_NUMBER_WARN4
          | :SEVERITY_NUMBER_ERROR
          | :SEVERITY_NUMBER_ERROR2
          | :SEVERITY_NUMBER_ERROR3
          | :SEVERITY_NUMBER_ERROR4
          | :SEVERITY_NUMBER_FATAL
          | :SEVERITY_NUMBER_FATAL2
          | :SEVERITY_NUMBER_FATAL3
          | :SEVERITY_NUMBER_FATAL4

  field(:SEVERITY_NUMBER_UNSPECIFIED, 0)
  field(:SEVERITY_NUMBER_TRACE, 1)
  field(:SEVERITY_NUMBER_TRACE2, 2)
  field(:SEVERITY_NUMBER_TRACE3, 3)
  field(:SEVERITY_NUMBER_TRACE4, 4)
  field(:SEVERITY_NUMBER_DEBUG, 5)
  field(:SEVERITY_NUMBER_DEBUG2, 6)
  field(:SEVERITY_NUMBER_DEBUG3, 7)
  field(:SEVERITY_NUMBER_DEBUG4, 8)
  field(:SEVERITY_NUMBER_INFO, 9)
  field(:SEVERITY_NUMBER_INFO2, 10)
  field(:SEVERITY_NUMBER_INFO3, 11)
  field(:SEVERITY_NUMBER_INFO4, 12)
  field(:SEVERITY_NUMBER_WARN, 13)
  field(:SEVERITY_NUMBER_WARN2, 14)
  field(:SEVERITY_NUMBER_WARN3, 15)
  field(:SEVERITY_NUMBER_WARN4, 16)
  field(:SEVERITY_NUMBER_ERROR, 17)
  field(:SEVERITY_NUMBER_ERROR2, 18)
  field(:SEVERITY_NUMBER_ERROR3, 19)
  field(:SEVERITY_NUMBER_ERROR4, 20)
  field(:SEVERITY_NUMBER_FATAL, 21)
  field(:SEVERITY_NUMBER_FATAL2, 22)
  field(:SEVERITY_NUMBER_FATAL3, 23)
  field(:SEVERITY_NUMBER_FATAL4, 24)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Logs.V1.LogRecordFlags do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :LOG_RECORD_FLAG_UNSPECIFIED | :LOG_RECORD_FLAG_TRACE_FLAGS_MASK

  field(:LOG_RECORD_FLAG_UNSPECIFIED, 0)
  field(:LOG_RECORD_FLAG_TRACE_FLAGS_MASK, 255)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Logs.V1.ResourceLogs do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          resource: SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource.t() | nil,
          instrumentation_library_logs: [
            SpandexOTLP.Opentelemetry.Proto.Logs.V1.InstrumentationLibraryLogs.t()
          ],
          schema_url: String.t()
        }
  defstruct [:resource, :instrumentation_library_logs, :schema_url]

  field(:resource, 1, type: SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource)

  field(:instrumentation_library_logs, 2,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Logs.V1.InstrumentationLibraryLogs
  )

  field(:schema_url, 3, type: :string)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Logs.V1.InstrumentationLibraryLogs do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          instrumentation_library:
            SpandexOTLP.Opentelemetry.Proto.Common.V1.InstrumentationLibrary.t() | nil,
          logs: [SpandexOTLP.Opentelemetry.Proto.Logs.V1.LogRecord.t()],
          schema_url: String.t()
        }
  defstruct [:instrumentation_library, :logs, :schema_url]

  field(:instrumentation_library, 1,
    type: SpandexOTLP.Opentelemetry.Proto.Common.V1.InstrumentationLibrary
  )

  field(:logs, 2, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Logs.V1.LogRecord)
  field(:schema_url, 3, type: :string)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Logs.V1.LogRecord do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          time_unix_nano: non_neg_integer,
          severity_number: SpandexOTLP.Opentelemetry.Proto.Logs.V1.SeverityNumber.t(),
          severity_text: String.t(),
          name: String.t(),
          body: SpandexOTLP.Opentelemetry.Proto.Common.V1.AnyValue.t() | nil,
          attributes: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()],
          dropped_attributes_count: non_neg_integer,
          flags: non_neg_integer,
          trace_id: binary,
          span_id: binary
        }
  defstruct [
    :time_unix_nano,
    :severity_number,
    :severity_text,
    :name,
    :body,
    :attributes,
    :dropped_attributes_count,
    :flags,
    :trace_id,
    :span_id
  ]

  field(:time_unix_nano, 1, type: :fixed64)

  field(:severity_number, 2,
    type: SpandexOTLP.Opentelemetry.Proto.Logs.V1.SeverityNumber,
    enum: true
  )

  field(:severity_text, 3, type: :string)
  field(:name, 4, type: :string)
  field(:body, 5, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.AnyValue)
  field(:attributes, 6, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue)
  field(:dropped_attributes_count, 7, type: :uint32)
  field(:flags, 8, type: :fixed32)
  field(:trace_id, 9, type: :bytes)
  field(:span_id, 10, type: :bytes)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.SpanKind do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :SPAN_KIND_UNSPECIFIED
          | :SPAN_KIND_INTERNAL
          | :SPAN_KIND_SERVER
          | :SPAN_KIND_CLIENT
          | :SPAN_KIND_PRODUCER
          | :SPAN_KIND_CONSUMER

  field(:SPAN_KIND_UNSPECIFIED, 0)
  field(:SPAN_KIND_INTERNAL, 1)
  field(:SPAN_KIND_SERVER, 2)
  field(:SPAN_KIND_CLIENT, 3)
  field(:SPAN_KIND_PRODUCER, 4)
  field(:SPAN_KIND_CONSUMER, 5)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status.DeprecatedStatusCode do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :DEPRECATED_STATUS_CODE_OK
          | :DEPRECATED_STATUS_CODE_CANCELLED
          | :DEPRECATED_STATUS_CODE_UNKNOWN_ERROR
          | :DEPRECATED_STATUS_CODE_INVALID_ARGUMENT
          | :DEPRECATED_STATUS_CODE_DEADLINE_EXCEEDED
          | :DEPRECATED_STATUS_CODE_NOT_FOUND
          | :DEPRECATED_STATUS_CODE_ALREADY_EXISTS
          | :DEPRECATED_STATUS_CODE_PERMISSION_DENIED
          | :DEPRECATED_STATUS_CODE_RESOURCE_EXHAUSTED
          | :DEPRECATED_STATUS_CODE_FAILED_PRECONDITION
          | :DEPRECATED_STATUS_CODE_ABORTED
          | :DEPRECATED_STATUS_CODE_OUT_OF_RANGE
          | :DEPRECATED_STATUS_CODE_UNIMPLEMENTED
          | :DEPRECATED_STATUS_CODE_INTERNAL_ERROR
          | :DEPRECATED_STATUS_CODE_UNAVAILABLE
          | :DEPRECATED_STATUS_CODE_DATA_LOSS
          | :DEPRECATED_STATUS_CODE_UNAUTHENTICATED

  field(:DEPRECATED_STATUS_CODE_OK, 0)
  field(:DEPRECATED_STATUS_CODE_CANCELLED, 1)
  field(:DEPRECATED_STATUS_CODE_UNKNOWN_ERROR, 2)
  field(:DEPRECATED_STATUS_CODE_INVALID_ARGUMENT, 3)
  field(:DEPRECATED_STATUS_CODE_DEADLINE_EXCEEDED, 4)
  field(:DEPRECATED_STATUS_CODE_NOT_FOUND, 5)
  field(:DEPRECATED_STATUS_CODE_ALREADY_EXISTS, 6)
  field(:DEPRECATED_STATUS_CODE_PERMISSION_DENIED, 7)
  field(:DEPRECATED_STATUS_CODE_RESOURCE_EXHAUSTED, 8)
  field(:DEPRECATED_STATUS_CODE_FAILED_PRECONDITION, 9)
  field(:DEPRECATED_STATUS_CODE_ABORTED, 10)
  field(:DEPRECATED_STATUS_CODE_OUT_OF_RANGE, 11)
  field(:DEPRECATED_STATUS_CODE_UNIMPLEMENTED, 12)
  field(:DEPRECATED_STATUS_CODE_INTERNAL_ERROR, 13)
  field(:DEPRECATED_STATUS_CODE_UNAVAILABLE, 14)
  field(:DEPRECATED_STATUS_CODE_DATA_LOSS, 15)
  field(:DEPRECATED_STATUS_CODE_UNAUTHENTICATED, 16)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status.StatusCode do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t :: integer | :STATUS_CODE_UNSET | :STATUS_CODE_OK | :STATUS_CODE_ERROR

  field(:STATUS_CODE_UNSET, 0)
  field(:STATUS_CODE_OK, 1)
  field(:STATUS_CODE_ERROR, 2)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.ResourceSpans do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          resource: SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource.t() | nil,
          instrumentation_library_spans: [
            SpandexOTLP.Opentelemetry.Proto.Trace.V1.InstrumentationLibrarySpans.t()
          ],
          schema_url: String.t()
        }
  defstruct [:resource, :instrumentation_library_spans, :schema_url]

  field(:resource, 1, type: SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource)

  field(:instrumentation_library_spans, 2,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.InstrumentationLibrarySpans
  )

  field(:schema_url, 3, type: :string)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.InstrumentationLibrarySpans do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          instrumentation_library:
            SpandexOTLP.Opentelemetry.Proto.Common.V1.InstrumentationLibrary.t() | nil,
          spans: [SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.t()],
          schema_url: String.t()
        }
  defstruct [:instrumentation_library, :spans, :schema_url]

  field(:instrumentation_library, 1,
    type: SpandexOTLP.Opentelemetry.Proto.Common.V1.InstrumentationLibrary
  )

  field(:spans, 2, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span)
  field(:schema_url, 3, type: :string)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.Event do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          time_unix_nano: non_neg_integer,
          name: String.t(),
          attributes: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()],
          dropped_attributes_count: non_neg_integer
        }
  defstruct [:time_unix_nano, :name, :attributes, :dropped_attributes_count]

  field(:time_unix_nano, 1, type: :fixed64)
  field(:name, 2, type: :string)
  field(:attributes, 3, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue)
  field(:dropped_attributes_count, 4, type: :uint32)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.Link do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          trace_id: binary,
          span_id: binary,
          trace_state: String.t(),
          attributes: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()],
          dropped_attributes_count: non_neg_integer
        }
  defstruct [:trace_id, :span_id, :trace_state, :attributes, :dropped_attributes_count]

  field(:trace_id, 1, type: :bytes)
  field(:span_id, 2, type: :bytes)
  field(:trace_state, 3, type: :string)
  field(:attributes, 4, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue)
  field(:dropped_attributes_count, 5, type: :uint32)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          trace_id: binary,
          span_id: binary,
          trace_state: String.t(),
          parent_span_id: binary,
          name: String.t(),
          kind: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.SpanKind.t(),
          start_time_unix_nano: non_neg_integer,
          end_time_unix_nano: non_neg_integer,
          attributes: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()],
          dropped_attributes_count: non_neg_integer,
          events: [SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.Event.t()],
          dropped_events_count: non_neg_integer,
          links: [SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.Link.t()],
          dropped_links_count: non_neg_integer,
          status: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status.t() | nil
        }
  defstruct [
    :trace_id,
    :span_id,
    :trace_state,
    :parent_span_id,
    :name,
    :kind,
    :start_time_unix_nano,
    :end_time_unix_nano,
    :attributes,
    :dropped_attributes_count,
    :events,
    :dropped_events_count,
    :links,
    :dropped_links_count,
    :status
  ]

  field(:trace_id, 1, type: :bytes)
  field(:span_id, 2, type: :bytes)
  field(:trace_state, 3, type: :string)
  field(:parent_span_id, 4, type: :bytes)
  field(:name, 5, type: :string)
  field(:kind, 6, type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.SpanKind, enum: true)
  field(:start_time_unix_nano, 7, type: :fixed64)
  field(:end_time_unix_nano, 8, type: :fixed64)
  field(:attributes, 9, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue)
  field(:dropped_attributes_count, 10, type: :uint32)
  field(:events, 11, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.Event)
  field(:dropped_events_count, 12, type: :uint32)
  field(:links, 13, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span.Link)
  field(:dropped_links_count, 14, type: :uint32)
  field(:status, 15, type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status)
end

defmodule SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          deprecated_code:
            SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status.DeprecatedStatusCode.t(),
          message: String.t(),
          code: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status.StatusCode.t()
        }
  defstruct [:deprecated_code, :message, :code]

  field(:deprecated_code, 1,
    type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status.DeprecatedStatusCode,
    deprecated: true,
    enum: true
  )

  field(:message, 2, type: :string)
  field(:code, 3, type: SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status.StatusCode, enum: true)
end

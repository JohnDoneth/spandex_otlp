defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.AggregationTemporality do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  @type t ::
          integer
          | :AGGREGATION_TEMPORALITY_UNSPECIFIED
          | :AGGREGATION_TEMPORALITY_DELTA
          | :AGGREGATION_TEMPORALITY_CUMULATIVE

  field :AGGREGATION_TEMPORALITY_UNSPECIFIED, 0
  field :AGGREGATION_TEMPORALITY_DELTA, 1
  field :AGGREGATION_TEMPORALITY_CUMULATIVE, 2
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.ResourceMetrics do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          resource: SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource.t() | nil,
          instrumentation_library_metrics: [
            SpandexOTLP.Opentelemetry.Proto.Metrics.V1.InstrumentationLibraryMetrics.t()
          ],
          schema_url: String.t()
        }
  defstruct [:resource, :instrumentation_library_metrics, :schema_url]

  field :resource, 1, type: SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource

  field :instrumentation_library_metrics, 2,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.InstrumentationLibraryMetrics

  field :schema_url, 3, type: :string
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.InstrumentationLibraryMetrics do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          instrumentation_library: SpandexOTLP.Opentelemetry.Proto.Common.V1.InstrumentationLibrary.t() | nil,
          metrics: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Metric.t()],
          schema_url: String.t()
        }
  defstruct [:instrumentation_library, :metrics, :schema_url]

  field :instrumentation_library, 1, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.InstrumentationLibrary
  field :metrics, 2, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Metric
  field :schema_url, 3, type: :string
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Metric do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data: {atom, any},
          name: String.t(),
          description: String.t(),
          unit: String.t()
        }
  defstruct [:data, :name, :description, :unit]

  oneof :data, 0

  field :name, 1, type: :string
  field :description, 2, type: :string
  field :unit, 3, type: :string
  field :int_gauge, 4, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntGauge, deprecated: true, oneof: 0
  field :gauge, 5, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Gauge, oneof: 0
  field :int_sum, 6, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntSum, deprecated: true, oneof: 0
  field :sum, 7, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Sum, oneof: 0

  field :int_histogram, 8,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntHistogram,
    deprecated: true,
    oneof: 0

  field :histogram, 9, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Histogram, oneof: 0
  field :summary, 11, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Summary, oneof: 0
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntGauge do
  @moduledoc false
  use Protobuf, deprecated: true, syntax: :proto3

  @type t :: %__MODULE__{
          data_points: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntDataPoint.t()]
        }
  defstruct [:data_points]

  field :data_points, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntDataPoint
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Gauge do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data_points: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.NumberDataPoint.t()]
        }
  defstruct [:data_points]

  field :data_points, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.NumberDataPoint
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntSum do
  @moduledoc false
  use Protobuf, deprecated: true, syntax: :proto3

  @type t :: %__MODULE__{
          data_points: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntDataPoint.t()],
          aggregation_temporality: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.AggregationTemporality.t(),
          is_monotonic: boolean
        }
  defstruct [:data_points, :aggregation_temporality, :is_monotonic]

  field :data_points, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntDataPoint

  field :aggregation_temporality, 2,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.AggregationTemporality,
    enum: true

  field :is_monotonic, 3, type: :bool
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Sum do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data_points: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.NumberDataPoint.t()],
          aggregation_temporality: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.AggregationTemporality.t(),
          is_monotonic: boolean
        }
  defstruct [:data_points, :aggregation_temporality, :is_monotonic]

  field :data_points, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.NumberDataPoint

  field :aggregation_temporality, 2,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.AggregationTemporality,
    enum: true

  field :is_monotonic, 3, type: :bool
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntHistogram do
  @moduledoc false
  use Protobuf, deprecated: true, syntax: :proto3

  @type t :: %__MODULE__{
          data_points: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntHistogramDataPoint.t()],
          aggregation_temporality: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.AggregationTemporality.t()
        }
  defstruct [:data_points, :aggregation_temporality]

  field :data_points, 1,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntHistogramDataPoint

  field :aggregation_temporality, 2,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.AggregationTemporality,
    enum: true
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Histogram do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data_points: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.HistogramDataPoint.t()],
          aggregation_temporality: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.AggregationTemporality.t()
        }
  defstruct [:data_points, :aggregation_temporality]

  field :data_points, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.HistogramDataPoint

  field :aggregation_temporality, 2,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.AggregationTemporality,
    enum: true
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Summary do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data_points: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.SummaryDataPoint.t()]
        }
  defstruct [:data_points]

  field :data_points, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.SummaryDataPoint
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntDataPoint do
  @moduledoc false
  use Protobuf, deprecated: true, syntax: :proto3

  @type t :: %__MODULE__{
          labels: [SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue.t()],
          start_time_unix_nano: non_neg_integer,
          time_unix_nano: non_neg_integer,
          value: integer,
          exemplars: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntExemplar.t()]
        }
  defstruct [:labels, :start_time_unix_nano, :time_unix_nano, :value, :exemplars]

  field :labels, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue
  field :start_time_unix_nano, 2, type: :fixed64
  field :time_unix_nano, 3, type: :fixed64
  field :value, 4, type: :sfixed64
  field :exemplars, 5, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntExemplar
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.NumberDataPoint do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any},
          attributes: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()],
          labels: [SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue.t()],
          start_time_unix_nano: non_neg_integer,
          time_unix_nano: non_neg_integer,
          exemplars: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Exemplar.t()]
        }
  defstruct [:value, :attributes, :labels, :start_time_unix_nano, :time_unix_nano, :exemplars]

  oneof :value, 0

  field :attributes, 7, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue

  field :labels, 1,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue,
    deprecated: true

  field :start_time_unix_nano, 2, type: :fixed64
  field :time_unix_nano, 3, type: :fixed64
  field :as_double, 4, type: :double, oneof: 0
  field :as_int, 6, type: :sfixed64, oneof: 0
  field :exemplars, 5, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Exemplar
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntHistogramDataPoint do
  @moduledoc false
  use Protobuf, deprecated: true, syntax: :proto3

  @type t :: %__MODULE__{
          labels: [SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue.t()],
          start_time_unix_nano: non_neg_integer,
          time_unix_nano: non_neg_integer,
          count: non_neg_integer,
          sum: integer,
          bucket_counts: [non_neg_integer],
          explicit_bounds: [float | :infinity | :negative_infinity | :nan],
          exemplars: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntExemplar.t()]
        }
  defstruct [
    :labels,
    :start_time_unix_nano,
    :time_unix_nano,
    :count,
    :sum,
    :bucket_counts,
    :explicit_bounds,
    :exemplars
  ]

  field :labels, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue
  field :start_time_unix_nano, 2, type: :fixed64
  field :time_unix_nano, 3, type: :fixed64
  field :count, 4, type: :fixed64
  field :sum, 5, type: :sfixed64
  field :bucket_counts, 6, repeated: true, type: :fixed64
  field :explicit_bounds, 7, repeated: true, type: :double
  field :exemplars, 8, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntExemplar
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.HistogramDataPoint do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributes: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()],
          labels: [SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue.t()],
          start_time_unix_nano: non_neg_integer,
          time_unix_nano: non_neg_integer,
          count: non_neg_integer,
          sum: float | :infinity | :negative_infinity | :nan,
          bucket_counts: [non_neg_integer],
          explicit_bounds: [float | :infinity | :negative_infinity | :nan],
          exemplars: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Exemplar.t()]
        }
  defstruct [
    :attributes,
    :labels,
    :start_time_unix_nano,
    :time_unix_nano,
    :count,
    :sum,
    :bucket_counts,
    :explicit_bounds,
    :exemplars
  ]

  field :attributes, 9, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue

  field :labels, 1,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue,
    deprecated: true

  field :start_time_unix_nano, 2, type: :fixed64
  field :time_unix_nano, 3, type: :fixed64
  field :count, 4, type: :fixed64
  field :sum, 5, type: :double
  field :bucket_counts, 6, repeated: true, type: :fixed64
  field :explicit_bounds, 7, repeated: true, type: :double
  field :exemplars, 8, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Exemplar
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.SummaryDataPoint.ValueAtQuantile do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          quantile: float | :infinity | :negative_infinity | :nan,
          value: float | :infinity | :negative_infinity | :nan
        }
  defstruct [:quantile, :value]

  field :quantile, 1, type: :double
  field :value, 2, type: :double
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.SummaryDataPoint do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributes: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()],
          labels: [SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue.t()],
          start_time_unix_nano: non_neg_integer,
          time_unix_nano: non_neg_integer,
          count: non_neg_integer,
          sum: float | :infinity | :negative_infinity | :nan,
          quantile_values: [SpandexOTLP.Opentelemetry.Proto.Metrics.V1.SummaryDataPoint.ValueAtQuantile.t()]
        }
  defstruct [
    :attributes,
    :labels,
    :start_time_unix_nano,
    :time_unix_nano,
    :count,
    :sum,
    :quantile_values
  ]

  field :attributes, 7, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue

  field :labels, 1,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue,
    deprecated: true

  field :start_time_unix_nano, 2, type: :fixed64
  field :time_unix_nano, 3, type: :fixed64
  field :count, 4, type: :fixed64
  field :sum, 5, type: :double

  field :quantile_values, 6,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Metrics.V1.SummaryDataPoint.ValueAtQuantile
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.IntExemplar do
  @moduledoc false
  use Protobuf, deprecated: true, syntax: :proto3

  @type t :: %__MODULE__{
          filtered_labels: [SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue.t()],
          time_unix_nano: non_neg_integer,
          value: integer,
          span_id: binary,
          trace_id: binary
        }
  defstruct [:filtered_labels, :time_unix_nano, :value, :span_id, :trace_id]

  field :filtered_labels, 1, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue
  field :time_unix_nano, 2, type: :fixed64
  field :value, 3, type: :sfixed64
  field :span_id, 4, type: :bytes
  field :trace_id, 5, type: :bytes
end

defmodule SpandexOTLP.Opentelemetry.Proto.Metrics.V1.Exemplar do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any},
          filtered_attributes: [SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue.t()],
          filtered_labels: [SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue.t()],
          time_unix_nano: non_neg_integer,
          span_id: binary,
          trace_id: binary
        }
  defstruct [:value, :filtered_attributes, :filtered_labels, :time_unix_nano, :span_id, :trace_id]

  oneof :value, 0

  field :filtered_attributes, 7, repeated: true, type: SpandexOTLP.Opentelemetry.Proto.Common.V1.KeyValue

  field :filtered_labels, 1,
    repeated: true,
    type: SpandexOTLP.Opentelemetry.Proto.Common.V1.StringKeyValue,
    deprecated: true

  field :time_unix_nano, 2, type: :fixed64
  field :as_double, 3, type: :double, oneof: 0
  field :as_int, 6, type: :sfixed64, oneof: 0
  field :span_id, 4, type: :bytes
  field :trace_id, 5, type: :bytes
end

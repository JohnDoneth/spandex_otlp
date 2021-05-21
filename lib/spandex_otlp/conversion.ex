defmodule SpandexOTLP.Conversion do
  @moduledoc false

  alias SpandexOTLP.Opentelemetry.Proto.Trace.V1.{ResourceSpans, InstrumentationLibrarySpans}
  alias SpandexOTLP.Opentelemetry.Proto.Common.V1.{AnyValue, KeyValue}
  alias SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span, as: OTLPSpan

  @resources Application.compile_env(:spandex_otlp, :resources, %{})

  @doc false
  @spec traces_to_resource_spans([Spandex.Trace.t()]) :: [ResourceSpans.t()]
  def traces_to_resource_spans(spandex_traces) do
    Enum.map(spandex_traces, fn spandex_trace ->
      %ResourceSpans{
        resource: resource(),
        instrumentation_library_spans: [
          instrumentation_library_spans(spandex_trace)
        ],
        schema_url: ""
      }
    end)
  end

  @spec instrumentation_library_spans(Spandex.Trace.t()) :: InstrumentationLibrarySpans.t()
  defp instrumentation_library_spans(spandex_trace) do
    {:ok, version} = :application.get_key(:spandex_otlp, :vsn)

    %InstrumentationLibrarySpans{
      instrumentation_library: %{
        name: "Spandex OTLP",
        version: version
      },
      spans: spans(spandex_trace),
      schema_url: ""
    }
  end

  @spec spans(Spandex.Trace.t()) :: [OTLPSpan.t()]
  defp spans(spandex_trace) do
    Enum.map(spandex_trace.spans, fn spandex_span ->
      %SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span{
        trace_id: spandex_span.trace_id,
        span_id: spandex_span.id,
        trace_state: "",
        parent_span_id: spandex_span.parent_id,
        name: spandex_span.name,
        kind: :SPAN_KIND_INTERNAL,
        start_time_unix_nano: spandex_span.start,
        end_time_unix_nano: spandex_span.completion_time,
        attributes: attributes_from_span_tags(spandex_span),
        dropped_attributes_count: 0,
        events: [],
        dropped_events_count: 0,
        links: [],
        dropped_links_count: 0,
        status: nil
      }
    end)
  end

  defp resource_attribute(%{resource: nil}), do: []
  defp resource_attribute(%{resource: resource}), do: [key_value("resource", resource)]

  defp sql_attributes(%{sql_query: nil}), do: []
  defp sql_attributes(%{sql_query: sql_query}) do
    [
      key_value("sql.query", sql_query[:query]),
      key_value("sql.rows", sql_query[:rows]),
      key_value("sql.db", sql_query[:db])
    ]
  end

  defp attributes_from_span_tags(spandex_span) do
    spandex_span.tags
    |> Enum.map(fn {key, value} ->
      %KeyValue{
        key: convert_key(key),
        value: %AnyValue{value: {:string_value, inspect(value)}}
      }
    end)
    |> Kernel.++(resource_attribute(spandex_span))
    |> Kernel.++(sql_attributes(spandex_span))
  end

  def convert_key(key) when is_atom(key), do: Atom.to_string(key)
  def convert_key(key) when is_binary(key), do: key
  def convert_key(key), do: inspect(key)

  defp key_value(key, value) do
    %KeyValue{
      key: key,
      value: %AnyValue{value: {:string_value, value}}
    }
  end

  defp resource do
    config_resources = Enum.map(@resources, fn {k, v} -> key_value(k, v) end)

    %SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource{
      attributes: config_resources ++ [
        key_value("library.language", "elixir"),
      ],
      dropped_attributes_count: 0
    }
  end
end

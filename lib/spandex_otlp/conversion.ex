defmodule SpandexOTLP.Conversion do
  @moduledoc false

  alias Spandex.Span

  alias SpandexOTLP.Opentelemetry.Proto.Trace.V1.{InstrumentationLibrarySpans, ResourceSpans}
  alias SpandexOTLP.Opentelemetry.Proto.Common.V1.{AnyValue, KeyValue}
  alias SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span, as: OTLPSpan

  @resources Application.compile_env(:spandex_otlp, SpandexOTLP)[:resources] || []

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

  defp instrumentation_library_spans(spandex_trace) do
    %InstrumentationLibrarySpans{
      instrumentation_library: %{
        name: "SpandexOTLP",
        version: library_version()
      },
      spans: spans(spandex_trace),
      schema_url: ""
    }
  end

  def convert_span(span) do
    %SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span{
      trace_id: span.trace_id,
      span_id: span.id,
      trace_state: "",
      parent_span_id: span.parent_id,
      name: span.name,
      kind: :SPAN_KIND_INTERNAL,
      start_time_unix_nano: span.start,
      end_time_unix_nano: span.completion_time,
      attributes: attributes_from_span_tags(span),
      dropped_attributes_count: 0,
      events: [],
      dropped_events_count: 0,
      links: [],
      dropped_links_count: 0,
      status: convert_status(span)
    }
  end

  defp convert_status(%Span{error: nil}) do
    %SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status{
      deprecated_code: :DEPRECATED_STATUS_CODE_OK,
      message: nil,
      code: :STATUS_CODE_OK
    }
  end

  defp convert_status(%Span{error: error}) do
    %SpandexOTLP.Opentelemetry.Proto.Trace.V1.Status{
      deprecated_code: :DEPRECATED_STATUS_CODE_UNAVAILABLE,
      message: error_message(error),
      code: :STATUS_CODE_ERROR
    }
  end

  @spec error_message(keyword()) :: String.t()
  defp error_message(error) do
    cond do
      Keyword.has_key?(error, :exception) ->
        Exception.message(error[:exception])

      Keyword.has_key?(error, :message) ->
        error[:message]

      true ->
        nil
    end
  end

  @spec spans(Spandex.Trace.t()) :: [OTLPSpan.t()]
  defp spans(spandex_trace) do
    Enum.map(spandex_trace.spans, &convert_span/1)
  end

  defp resource_attribute(%Span{resource: nil}), do: []
  defp resource_attribute(%Span{resource: resource}), do: [key_value("resource", resource)]

  defp sql_attributes(%Span{sql_query: nil}), do: []

  defp sql_attributes(%Span{sql_query: sql_query}) do
    [
      key_value("sql.query", sql_query[:query]),
      key_value("sql.rows", sql_query[:rows]),
      key_value("sql.db", sql_query[:db])
    ]
  end

  defp error_attributes(%Span{error: error}) do
    %{}
    |> add_error_type(error[:exception])
    |> add_error_message(error[:exception])
    |> add_error_stacktrace(error[:stacktrace])
    |> Map.to_list()
    |> Enum.map(fn {key, value} -> key_value(key, value) end)
  end

  @spec add_error_type(map(), Exception.t() | nil) :: map()
  defp add_error_type(attrs, nil), do: attrs

  defp add_error_type(attrs, exception) do
    Map.put(attrs, "exception.type", inspect(exception.__struct__))
  end

  @spec add_error_message(map(), Exception.t() | nil) :: map()
  defp add_error_message(attrs, nil), do: attrs

  defp add_error_message(attrs, exception) do
    Map.put(attrs, "exception.message", Exception.message(exception))
  end

  @spec add_error_stacktrace(map(), Exception.t() | nil) :: map()
  defp add_error_stacktrace(attrs, nil), do: attrs

  defp add_error_stacktrace(attrs, stacktrace) do
    Map.put(attrs, "exception.stacktrace", Exception.format_stacktrace(stacktrace))
  end

  defp attributes_from_span_tags(spandex_span) do
    spandex_span.tags
    |> Enum.map(fn {key, value} ->
      key_value(key, value)
    end)
    |> Kernel.++(resource_attribute(spandex_span))
    |> Kernel.++(sql_attributes(spandex_span))
    |> Kernel.++(error_attributes(spandex_span))
  end

  def convert_key(key) when is_atom(key), do: Atom.to_string(key)
  def convert_key(key) when is_binary(key), do: key
  def convert_key(key), do: inspect(key)

  defp convert_value(value) when is_binary(value) do
    %AnyValue{value: {:string_value, value}}
  end

  defp convert_value(value) when is_integer(value) do
    %AnyValue{value: {:int_value, value}}
  end

  defp convert_value(value) when is_boolean(value) do
    %AnyValue{value: {:bool_value, value}}
  end

  defp convert_value(value), do: convert_value(inspect(value))

  defp key_value(key, value) do
    %KeyValue{
      key: convert_key(key),
      value: convert_value(value)
    }
  end

  defp resource do
    config_resources = Enum.map(@resources, fn {k, v} -> key_value(k, v) end)

    %SpandexOTLP.Opentelemetry.Proto.Resource.V1.Resource{
      attributes:
        config_resources ++
          [
            key_value("library.name", "SpandexOTLP"),
            key_value("library.language", "elixir"),
            key_value("library.version", library_version())
          ],
      dropped_attributes_count: 0
    }
  end

  defp library_version do
    {:ok, version} = :application.get_key(:spandex_otlp, :vsn)
    :binary.list_to_bin(version)
  end
end

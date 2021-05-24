defmodule SpandexOTLP.ConversionTest do
  @moduledoc false

  use ExUnit.Case

  alias SpandexOTLP.Conversion
  alias SpandexOTLP.Opentelemetry.Proto.Common.V1.{AnyValue, KeyValue}
  alias SpandexOTLP.Opentelemetry.Proto.Trace.V1.Span

  describe "convert_span/1" do
    setup do
      original_span = %Spandex.Span{
        id: SpandexOTLP.Adapter.span_id(),
        trace_id: SpandexOTLP.Adapter.trace_id(),
        private: [],
        services: [],
        sql_query: [
          query: "select 1",
          rows: 1,
          db: "my-db"
        ],
        tags: [
          "test-tag": "42"
        ]
      }

      %{
        original_span: original_span,
        converted_span: Conversion.convert_span(original_span)
      }
    end

    test "converts the span id", %{converted_span: converted_span} do
      assert byte_size(converted_span.span_id) == 8
    end

    test "converts the trace_id", %{converted_span: converted_span} do
      assert byte_size(converted_span.trace_id) == 16
    end

    test "converts tags to attributes", %{converted_span: converted_span} do
      assert Enum.member?(
               converted_span.attributes,
               %KeyValue{
                 key: "test-tag",
                 value: %AnyValue{
                   value: {:string_value, "42"}
                 }
               }
             )
    end

    test "converts sql_query to attributes", %{converted_span: converted_span} do
      assert Enum.member?(
               converted_span.attributes,
               %KeyValue{
                 key: "sql.query",
                 value: %AnyValue{
                   value: {:string_value, "select 1"}
                 }
               }
             )

      assert Enum.member?(
               converted_span.attributes,
               %KeyValue{
                 key: "sql.rows",
                 value: %AnyValue{
                   value: {:int_value, 1}
                 }
               }
             )

      assert Enum.member?(
               converted_span.attributes,
               %KeyValue{
                 key: "sql.db",
                 value: %AnyValue{
                   value: {:string_value, "my-db"}
                 }
               }
             )
    end

    test "result can be protobuf encoded", %{converted_span: converted_span} do
      Span.encode(converted_span)
    end

    test "converts exceptions to errors" do
      {:current_stacktrace, stacktrace} = Process.info(self(), :current_stacktrace)

      converted_span = Conversion.convert_span(span_factory(
        error: [
          exception: ArgumentError.exception("foo"),
          stacktrace: stacktrace
        ]
      ))

      assert converted_span.status.code == :STATUS_CODE_ERROR
      assert converted_span.status.message == "foo"

      assert Enum.member?(
               converted_span.attributes,
               %KeyValue{
                 key: "exception.message",
                 value: %AnyValue{
                   value: {:string_value, "foo"}
                 }
               }
             )

      assert Enum.member?(
              converted_span.attributes,
              %KeyValue{
                key: "exception.type",
                value: %AnyValue{
                  value: {:string_value, "ArgumentError"}
                }
              }
            )

      assert Enum.member?(
              converted_span.attributes,
              %KeyValue{
                key: "exception.stacktrace",
                value: %AnyValue{
                  value: {:string_value, Exception.format_stacktrace(stacktrace)}
                }
              }
            )
    end

    test "converts message only errors to errors" do
      {:current_stacktrace, stacktrace} = Process.info(self(), :current_stacktrace)

      converted_span = Conversion.convert_span(span_factory(
        error: [
          message: "something bad happened"
        ]
      ))

      assert converted_span.status.code == :STATUS_CODE_ERROR
      assert converted_span.status.message == "something bad happened"
    end

    test "converts message with error? flag" do
      {:current_stacktrace, stacktrace} = Process.info(self(), :current_stacktrace)

      converted_span = Conversion.convert_span(span_factory(
        error: [
          error?: true
        ]
      ))

      assert converted_span.status.code == :STATUS_CODE_ERROR
      assert converted_span.status.message == nil
    end
  end

  defp span_factory(opts) do
    fields = %{
      id: SpandexOTLP.Adapter.span_id(),
      trace_id: SpandexOTLP.Adapter.trace_id(),
      private: [],
      services: [],
      sql_query: [
        query: "select 1",
        rows: 1,
        db: "my-db"
      ],
      tags: [
        "test-tag": "42"
      ]
    }

    fields = Map.merge(fields, Enum.into(opts, %{}))

    struct(Spandex.Span, fields)
  end
end

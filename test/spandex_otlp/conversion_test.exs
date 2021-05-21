defmodule SpandexOTLP.ConversionTest do
  use ExUnit.Case

  alias SpandexOTLP.Conversion

  describe "traces_to_resource_span/1" do
    test "converts `Spandex.Trace`s correctly" do

      trace_id = "trace_id"
      start_time = 0
      end_time = 100

      [resource_span] = Conversion.traces_to_resource_spans([
        %Spandex.Trace{
          baggage: [],
          id: trace_id,
          priority: 0,
          spans: [%Spandex.Span{
            trace_id: trace_id,
            start: start_time,
            completion_time: end_time,
            name: "My cool span",
            parent_id: "parent_span"
          }],
          stack: [],
        }
      ])
    end
  end
end

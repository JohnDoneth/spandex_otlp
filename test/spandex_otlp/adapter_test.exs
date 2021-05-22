defmodule SpandexOTLP.AdapterTest do
  use ExUnit.Case, async: true

  alias SpandexOTLP.Adapter

  describe "now/1" do
    test "returns the time in nanoseconds" do
      t1 = Adapter.now()
      t2 = Adapter.now()

      assert t1 <= t2
    end
  end

  describe "span_id/1" do
    test "returns a unique span identifier" do
      assert Adapter.span_id() != Adapter.span_id()
    end
  end

  describe "trace_id/1" do
    test "returns a unique trace identifier" do
      assert Adapter.trace_id() != Adapter.trace_id()
    end
  end
end

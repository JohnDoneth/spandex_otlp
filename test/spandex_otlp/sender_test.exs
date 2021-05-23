defmodule SpandexOTLP.SenderTest do
  use SpandexOTLP.Integration.TestCase

  describe "init/2" do
    # test "returns an error if connecting fails" do
    #   ExUnit.CaptureLog.capture_log(fn ->
    #     {:stop, reason} = SpandexOTLP.Sender.start_link(endpoint: "localhost:0")

    #     assert reason =~ "Error when opening connection"
    #   end)
    # end
  end

  describe "send_trace/2" do
    test "is recieved by the server process" do
      run_endpoint(SpandexOTLP.TestEndpoint, fn ->
        ExUnit.CaptureLog.capture_log(fn ->
          SpandexOTLP.Sender.send_trace(%Spandex.Trace{})

          requests = SpandexOTLP.RequestStore.requests()

          assert length(requests) == 1
        end)
      end)
    end

    test "sends a trace" do
      run_endpoint(SpandexOTLP.TestEndpoint, fn ->
        ExUnit.CaptureLog.capture_log(fn ->
          SpandexOTLP.Sender.send_trace(%Spandex.Trace{id: "1234"})

          # [request] = SpandexOTLP.RequestStore.requests()
          # assert request
        end)
      end)
    end
  end
end

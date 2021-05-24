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
      run_endpoint(
        SpandexOTLP.TestEndpoint,
        fn ->
          ExUnit.CaptureLog.capture_log(fn ->
            SpandexOTLP.Sender.send_trace(%Spandex.Trace{})

            requests = SpandexOTLP.RequestStore.requests()

            assert length(requests) == 1
          end)
        end,
        batch: %{
          send_batch_size: 1,
          timeout: {999_999, :milliseconds}
        }
      )
    end

    test "batches traces until the threshhold is hit" do
      run_endpoint(
        SpandexOTLP.TestEndpoint,
        fn ->
          ExUnit.CaptureLog.capture_log(fn ->
            SpandexOTLP.Sender.send_trace(%Spandex.Trace{id: "1234"})

            assert [] == SpandexOTLP.RequestStore.requests()

            # Trigger limit
            SpandexOTLP.Sender.send_trace(%Spandex.Trace{id: "2345"})

            # Batch limit was hit. We now expect two root resource spans.
            [request] = SpandexOTLP.RequestStore.requests()
            assert length(request.resource_spans) == 2
          end)
        end,
        batch: %{
          send_batch_size: 2,
          timeout: {999_999, :milliseconds}
        }
      )
    end

    test "batches traces until the timeout is hit" do
      run_endpoint(
        SpandexOTLP.TestEndpoint,
        fn ->
          ExUnit.CaptureLog.capture_log(fn ->
            SpandexOTLP.Sender.send_trace(%Spandex.Trace{id: "1234"})

            assert [] == SpandexOTLP.RequestStore.requests()

            # Wait for the required time
            Process.sleep(1000)

            # Time limit has elapsed. We now expect a resource span.
            requests = SpandexOTLP.RequestStore.requests()
            assert length(requests) > 0
          end)
        end,
        batch: %{
          send_batch_size: 9999,
          timeout: {200, :milliseconds}
        }
      )
    end
  end
end

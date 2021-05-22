defmodule SpandexOTLP.Integration.TestCase do
  @moduledoc false

  use ExUnit.CaseTemplate, async: false

  require Logger

  using do
    quote do
      import SpandexOTLP.Integration.TestCase

      setup :setup_request_store
    end
  end

  def setup_request_store(_) do
    SpandexOTLP.RequestStore.start_link()
    :ok
  end

  def run_endpoint(endpoint, func, options \\ []) do
    {:ok, _pid, port} =
      if options[:dont_start_remote] do
        {:ok, 0, 0}
      else
        GRPC.Server.start_endpoint(endpoint, 0)
      end

    SpandexOTLP.Sender.start_link(endpoint: "localhost:#{port}")

    try do
      func.()
    after
      :ok = GRPC.Server.stop_endpoint(endpoint, [])
    end
  end
end

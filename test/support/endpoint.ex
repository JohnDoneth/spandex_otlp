defmodule SpandexOTLP.TestEndpoint do
  @moduledoc false

  use GRPC.Endpoint

  intercept(GRPC.Logger.Server)
  run(SpandexOTLP.TestServer)
end

defmodule SpandexOTLP.RequestStore do
  @moduledoc """
  Stores requests made to certain ports for retrieval by tests
  """
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {:ok,
     %{
       requests: []
     }}
  end

  @impl true
  def handle_call(:get_requests, _from, state) do
    {:reply, state.requests, state}
  end

  @impl true
  def handle_call({:put_request, request}, _from, state) do
    new_state =
      state
      |> Map.update!(:requests, fn requests -> requests ++ [request] end)

    {:reply, :ok, new_state}
  end

  def requests do
    GenServer.call(__MODULE__, :get_requests)
  end

  def put_request(request) do
    GenServer.call(__MODULE__, {:put_request, request})
  end
end

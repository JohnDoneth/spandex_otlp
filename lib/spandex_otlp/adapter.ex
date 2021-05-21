defmodule SpandexOTLP.Adapter do
  @moduledoc """
  A OTLP APM implementation for Spandex.
  """

  @behaviour Spandex.Adapter

  @max_id 9_223_372_036_854_775_807

  @impl true
  def default_sender(), do: SpandexOTLP.Sender

  @impl true
  def distributed_context(_arg1, _arg2) do
    # Not yet implemented
    {:error, :no_distributed_trace}
  end

  @impl true
  def inject_context(headers, _arg2, _arg3), do: headers

  @impl true
  def now(), do: :os.system_time(:nano_seconds)

  @impl true
  def span_id(), do: trace_id()

  @impl true
  def trace_id(), do: :rand.uniform(@max_id)
end

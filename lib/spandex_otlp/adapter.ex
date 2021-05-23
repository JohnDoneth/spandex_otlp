defmodule SpandexOTLP.Adapter do
  @moduledoc """
  A OTLP APM implementation for Spandex.
  """

  @behaviour Spandex.Adapter

  @impl true
  def default_sender, do: SpandexOTLP.Sender

  @impl true
  def distributed_context(_arg1, _arg2) do
    # Not yet implemented
    {:error, :no_distributed_trace}
  end

  @impl true
  def inject_context(headers, _arg2, _arg3), do: headers

  @impl true
  def now, do: :os.system_time(:nano_seconds)

  @impl true
  def span_id, do: random_binary(64)

  @impl true
  def trace_id, do: random_binary(128)

  defp random_binary(bits) do
    1..div(bits, 8)
    |> Enum.map(fn _ -> :rand.uniform(255) end)
    |> :binary.list_to_bin()
  end
end

defmodule PowRec.Logger do
  use GenServer

  def start(log_name) do
    case File.open(log_name <> ".dat", [:write]) do
      {:ok, log_handle} ->
        GenServer.start(PowRec.Logger, [log_name, log_handle])

      {:error, e} ->
        {:error, e}
    end
  end

  # ----- PowRec.Logger callbacks -----

  @impl true
  def init([log_name, log_handle]) do
    init_time = System.monotonic_time(:microsecond)
    {:ok, %{log_name: log_name, log_handle: log_handle, init_time: init_time}}
  end

  @impl true
  def handle_info({:measurement, time, current}, state) do
    entry_time = time - state.init_time
    IO.binwrite(state.log_handle, "#{entry_time / 1_000_000}, #{current}\n")
    {:noreply, state}
  end
end

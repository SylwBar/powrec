defmodule PowRec.Display do
  @display_rate_ms 500

  use GenServer

  def start(channel_pid) do
    GenServer.start(PowRec.Display, [channel_pid])
  end

  def toggle(display_pid) do
    GenServer.cast(display_pid, :toggle_display)
  end

  # ----- PowRec.Display callbacks -----

  @impl true
  def init([channel_pid]) do
    {:ok, %{timer_ref: nil, channel_pid: channel_pid}}
  end

  @impl true
  def handle_cast(:toggle_display, state) do
    if state.timer_ref == nil do
      {:ok, timer_ref} = :timer.send_interval(@display_rate_ms, :display_tick)
      {:noreply, %{state | timer_ref: timer_ref}}
    else
      :timer.cancel(state.timer_ref)
      {:noreply, %{state | timer_ref: nil}}
    end
  end

  @impl true
  def handle_info(:display_tick, state) do
    {current, voltage} = PowRec.Channel.get_measurements(state.channel_pid)
    current_str = get_current_str(current)
    voltage_str = get_voltage_str(voltage)
    IO.write("ch1: " <> current_str <> ", " <> voltage_str <> "   \r")
    {:noreply, state}
  end

  defp get_current_str(current) do
    ra = :erlang.float_to_binary(current, decimals: 1)
    "#{ra} mA"
  end

  defp get_voltage_str(voltage) do
    rv = :erlang.float_to_binary(voltage, decimals: 3)
    "#{rv} V"
  end
end

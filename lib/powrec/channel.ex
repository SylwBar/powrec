defmodule PowRec.Channel do
  use GenServer

  def start(logger_pid, opts) do
    try do
      {:ok, i2c_conn} = Wafer.Driver.Circuits.I2C.acquire(bus_name: "i2c-1", address: 0x40)
      {:ok, i2c_conn} = INA219.acquire(conn: i2c_conn, current_divisor: 20, power_divisor: 1)

      {:ok, i2c_conn} =
        if opts.low do
          INA219.calibrate_16V_400mA(i2c_conn)
        else
          INA219.calibrate_32V_2A(i2c_conn)
        end

      GenServer.start(PowRec.Channel, [logger_pid, i2c_conn])
    rescue
      e in MatchError -> e.term
    end
  end

  def get_measurements(channel_pid) do
    GenServer.call(channel_pid, :get_meas)
  end

  # ----- PowRec.Channel callbacks -----

  @impl true
  def init([logger_pid, i2c_conn]) do
    {:ok, %{logger_pid: logger_pid, i2c_conn: i2c_conn, measurements: 0}}
  end

  @impl true
  def handle_info(:tick, state) do
    {:ok, current} = INA219.current(state.i2c_conn)
    time = System.monotonic_time(:microsecond)
    send(state.logger_pid, {:measurement, time, current})
    {:noreply, %{state | measurements: current}}
  end

  @impl true
  def handle_call(:get_meas, _from, state) do
    {:reply, state.measurements, state}
  end
end

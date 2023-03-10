defmodule PowRec.Channel do
  use GenServer

  def start(logger_pid, opts) do
    try do
      {:ok, i2c_conn} = Wafer.Driver.Circuits.I2C.acquire(bus_name: "i2c-1", address: opts.addr)

      {:ok, i2c_conn} =
        if opts.low do
          {:ok, i2c_conn} = INA219.acquire(conn: i2c_conn, current_divisor: 20, power_divisor: 1)
          INA219.calibrate_16V_400mA(i2c_conn)
        else
          {:ok, i2c_conn} = INA219.acquire(conn: i2c_conn, current_divisor: 10, power_divisor: 2)
          INA219.calibrate_32V_2A(i2c_conn)
        end

      GenServer.start(PowRec.Channel, [logger_pid, i2c_conn])
    rescue
      e in MatchError ->
        case e.term do
          {:error, error} -> {:i2c_error, error}
        end
    end
  end

  def get_measurements(channel_pid) do
    GenServer.call(channel_pid, :get_measurements)
  end

  # ----- PowRec.Channel callbacks -----

  @impl true
  def init([logger_pid, i2c_conn]) do
    {:ok, %{logger_pid: logger_pid, i2c_conn: i2c_conn, current: nil, voltage: nil}}
  end

  @impl true
  def handle_info(:tick, state) do
    {:ok, voltage} = INA219.bus_voltage(state.i2c_conn)
    {:ok, current} = INA219.current(state.i2c_conn)
    time = System.monotonic_time(:microsecond)
    send(state.logger_pid, {:measurement, time, current, voltage})
    {:noreply, %{state | current: current, voltage: voltage}}
  end

  @impl true
  def handle_call(:get_measurements, _from, state) do
    {:reply, {state.current, state.voltage}, state}
  end
end

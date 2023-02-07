defmodule PowRec.Gnuplot do
  def write_plot(opts) do
    plot_i_file_name = opts.out_name <> "_I.plot"
    plot_u_file_name = opts.out_name <> "_U.plot"
    log_file_name = opts.out_name <> ".dat"

    case File.open(plot_i_file_name, [:write]) do
      {:ok, plot_handle} ->
        IO.write(plot_handle, """
        set xlabel "Time [s]"
        set ylabel "Current [mA]"
        set grid
        plot '#{log_file_name}' using 1:2 title '#{log_file_name} 1:2' with lines
        pause mouse close
        """)

        File.close(plot_handle)

      {:error, e} ->
        IO.inspect(e)
    end

    case File.open(plot_u_file_name, [:write]) do
      {:ok, plot_handle} ->
        IO.write(plot_handle, """
        set xlabel "Time [s]"
        set ylabel "Voltage [V]"
        set grid
        plot '#{log_file_name}' using 1:3 title '#{log_file_name} 1:3' with lines
        pause mouse close
        """)

        File.close(plot_handle)

      {:error, e} ->
        IO.inspect(e)
    end
  end
end

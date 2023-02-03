defmodule PowRec.Gnuplot do
  def write_plot(opts) do
    plot_file_name = opts.out_name <> ".plot"
    log_file_name = opts.out_name <> ".dat"

    case File.open(plot_file_name, [:write]) do
      {:ok, plot_handle} ->
        IO.write(plot_handle, """
        plot '#{log_file_name}' with lines
        pause mouse close
        """)

        File.close(plot_handle)

      {:error, e} ->
        IO.inspect(e)
    end
  end
end

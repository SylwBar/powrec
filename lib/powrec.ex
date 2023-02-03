defmodule PowRec do
  def main(argv) do
    IO.puts("PowRec #{Application.spec(:powrec, :vsn)}")

    case PowRec.Opts.parse(argv) do
      :help_requested -> PowRec.Opts.print_help()
      {:error, message} -> IO.puts(message)
      {:ok, opts} -> run(opts)
    end
  end

  defp run(opts) do
    {:ok, logger_pid} = PowRec.Logger.start(opts.out_name)
    {:ok, channel_pid} = PowRec.Channel.start(logger_pid, opts)
    {:ok, display_pid} = PowRec.Display.start(channel_pid)

    :timer.send_interval(opts.int_ms, channel_pid, :tick)
    IO.puts("Enter h - for help")
    command_loop(%{display_pid: display_pid, opts: opts})
  end

  defp command_loop(args) do
    case IO.gets("powrec> ") |> String.trim("\n") do
      "d" ->
        PowRec.Display.toggle(args.display_pid)
        command_loop(args)

      "h" ->
        print_cmd_help()
        command_loop(args)

      "i" ->
        print_info(args.opts)
        command_loop(args)

      "q" ->
        PowRec.Gnuplot.write_plot(args.opts)
        :ok

      cmd ->
        IO.puts("Not recognized command: #{cmd}")
        command_loop(args)
    end
  end

  defp print_cmd_help() do
    IO.puts("""
    powrec commands:
    d: toggle display
    i: print info
    h: help
    q: quit program
    """)
  end

  defp print_info(opts) do
    {volt_range, amps_range} =
      if opts.low do
        {16, 0.4}
      else
        {32, 2.0}
      end

    IO.puts("""
    PowRec runtime information:
    Sampling interval: #{opts.int_ms} ms
    Voltage range: #{volt_range} V
    Current range: #{amps_range} A
    """)
  end
end

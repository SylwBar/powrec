defmodule PowRec.Opts do
  @def_int_ms 100
  @def_out_name "out"
  @def_low false
  @def_addr 64

  def parse(argv) do
    try do
      {opt_list, _arg_list} =
        OptionParser.parse!(argv,
          strict: [
            help: :boolean,
            int_ms: :integer,
            out: :string,
            low: :boolean,
            addr: :integer
          ],
          aliases: [
            h: :help,
            m: :int_ms,
            o: :out,
            l: :low,
            a: :addr
          ]
        )

      if :proplists.get_value(:help, opt_list) == true do
        :help_requested
      else
        opts = %{
          int_ms: :proplists.get_value(:int_ms, opt_list, @def_int_ms),
          out_name: :proplists.get_value(:out, opt_list, @def_out_name),
          low: :proplists.get_value(:low, opt_list, @def_low),
          addr: :proplists.get_value(:addr, opt_list, @def_addr)
        }

        {:ok, opts}
      end
    rescue
      e in OptionParser.ParseError ->
        {:error, e.message}
    end
  end

  def print_help() do
    IO.puts("""
    Usage: powrec [OPTION [ARGS]]
     -h, --help      print help
     -m, --int-ms    sampling interval in ms, default: #{@def_int_ms}
     -o, --out       output files prefix, default: #{@def_out_name}
     -l, --low       low measurement range: 16V, 0.4 A, default: #{@def_low}
     -a, --addr      INA219 I2C address, default: #{@def_addr}
    """)
  end
end

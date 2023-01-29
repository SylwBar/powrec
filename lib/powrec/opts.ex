defmodule PowRec.Opts do
  @def_int_ms 100
  @def_log_name "log"

  def parse(argv) do
    try do
      {opt_list, _arg_list} =
        OptionParser.parse!(argv,
          strict: [
            help: :boolean,
            int_ms: :integer,
            log_name: :string
          ],
          aliases: [
            h: :help,
            m: :int_ms,
            l: :log_name
          ]
        )

      if :proplists.get_value(:help, opt_list) == true do
        :help_requested
      else
        opts = %{
          int_ms: :proplists.get_value(:int_ms, opt_list, @def_int_ms),
          log_name: :proplists.get_value(:log_name, opt_list, @def_log_name)
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
    powrec args:
    --help,     -h: print help
    --int-ms,   -m: sampling interval in ms
    --log_name, -l: log name (without suffix)
    """)
  end
end

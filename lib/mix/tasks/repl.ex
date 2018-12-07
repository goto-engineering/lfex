defmodule Mix.Tasks.Repl do
  use Mix.Task

  @shortdoc "Start the Lfex REPL"
  def run(_) do 
    Lfex.repl()
  end
end

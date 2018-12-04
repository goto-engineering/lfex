defmodule Lfex do
  def interpret(program) do
    program
    |> Parse.parse
    |> Eval.eval
  end

  def to_lfex_string(expr) when is_atom(expr), do: ":#{expr}"
  def to_lfex_string(expr) when is_binary(expr), do: ~s("#{expr}")
  def to_lfex_string(expr) when is_list(expr) do
    string = expr
             |> Enum.map(&to_lfex_string/1)
             |> Enum.join(" ")
    "[#{string}]"
  end
  def to_lfex_string(expr), do: to_string(expr)

  def repl do
    program = IO.gets "lfex> "
    result  = program |> interpret()
    result |> to_lfex_string |> IO.puts
    repl()
  end
end

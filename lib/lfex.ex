defmodule Lfex do
  def interpret(program) do
    program
    |> Parse.parse
    |> Eval.eval()
  end

  def to_lfex_string(exp) do
    case is_list(exp) do
      true -> "(" <> (Enum.map(exp,fn x -> to_lfex_string(x) end) |> Enum.join(" ")) <> ")"  
      false -> to_string(exp)
    end
  end

  def repl do
    program = IO.gets "lfex> "
    {result}  = program |> interpret()
    result |> to_lfex_string |> IO.puts
    repl()
  end
end

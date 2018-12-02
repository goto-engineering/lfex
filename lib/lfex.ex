defmodule Lfex do
  def interpret(program, env) do
    program
    |> Parse.parse
    |> Eval.eval(env, 0)
  end

  def to_lfex_string(exp) do
    case is_list(exp) do
      true -> "(" <> (Enum.map(exp,fn x -> to_lfex_string(x) end) |> Enum.join(" ")) <> ")"  
      false -> to_string(exp)
    end
  end

  def repl(env \\ nil) do
    program = IO.gets "lfex> "
    {result, env}  = program |> interpret(env)
    result |> to_lfex_string |> IO.puts
    repl(env)
  end
end

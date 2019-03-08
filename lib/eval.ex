defmodule Eval do
  def eval(expr) do
    # IO.inspect(expr, label: "before eval")
    Code.eval_quoted(expr)
    # |> IO.inspect(label: "after eval")
    |> elem(0)
    # |> IO.inspect(label: "return value")
  end
end

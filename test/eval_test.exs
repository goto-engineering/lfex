defmodule EvalTest do
  use ExUnit.Case

  test "evals a number" do
    assert Eval.eval(2) == 2
  end

  test "evals a string" do
    assert Eval.eval("Bob") == "Bob"
  end

  test "evals an atom" do
    assert Eval.eval(:bob) == :bob
  end

  test "evals a list" do
    expr = """
    (Enum.join ["Bob" "Jane"] "and")
    """
    |> Parse.parse
    assert Eval.eval(expr) == "BobandJane"
  end
end

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
    [1 :jeff ["Bob" "Jane"] " and "]
    """
    |> Parse.parse

    assert Eval.eval(expr) == [1, :jeff, ["Bob", "Jane"], " and "]
  end

  test "evals a tuple" do
    expr = """
    {{"Jose" "Rich"} {:brazil :usa}}
    """
    |> Parse.parse

    assert Eval.eval(expr) == {{"Jose", "Rich"}, {:brazil, :usa}}
  end

  test "evals massive nested data structures" do
    expr = """
    [{:alice "Bob" [:charlie {:dorothy}, :straycomma 3] "Theodore Roosevelt" 26 }
     {:hello "This is the " :magic " Sword"}]
    """
    |> Parse.parse

    assert Eval.eval(expr) == {{"Jose", "Rich"}, {:brazil, :usa}}
  end

  test "evals a function call" do
    expr = """
    (Enum.join ["Bob" "Jane"] " and ")
    """
    |> Parse.parse

    assert Eval.eval(expr) == "Bob and Jane"
  end

  test "evals operators" do
    expr = """
    (* 2 4)
    """
    |> Parse.parse

    assert Eval.eval(expr) == 8
  end
end

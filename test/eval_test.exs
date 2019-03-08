defmodule EvalTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

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

  test "evals weird nested tuples" do
    expr = """
    {{"Jose" "Rich"}}
    """
    |> Parse.parse

    assert Eval.eval(expr) == {{"Jose", "Rich"}}
  end

  test "evals maps" do
    expr = """
    %{:user %{:name "Alice" :age 30}}
    """
    |> Parse.parse

    assert Eval.eval(expr) == %{user: %{name: "Alice", age: 30}}

    expr = """
    %{:users [%{:name "Alice" :age 30}
              %{:name "Bob" :age 42}
              %{:name "Charlie" :age 12}]
      :admin true}
    """
    |> Parse.parse

    assert Eval.eval(expr) == %{
      :users => [
        %{name: "Alice", age: 30},
        %{name: "Bob", age: 42},
        %{name: "Charlie", age: 12}
      ],
      admin: true
    }
  end

  test "evals massive nested data structures" do
    expr = """
    [{:alice "Bob" [:charlie {:dorothy}, :straycomma 3] "Theodore Roosevelt" 26 }
     {:hello "This is the " :magic " Sword"}]
    """
    |> Parse.parse

    assert Eval.eval(expr) == [
      {:alice, "Bob", [:charlie, {:dorothy}, :straycomma, 3], "Theodore Roosevelt", 26},
      {:hello, "This is the ", :magic, " Sword"}
    ]
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

  test "evals nested expressions" do
    expr = """
    (* 2 (+ 3 4))
    """
    |> Parse.parse

    assert Eval.eval(expr) == 14
  end

  test "evals several expressions on multiple lines" do
    expr = """
    (IO.puts "Hi")

    (IO.puts "Ok")
    """
    |> Parse.parse

    assert capture_io(fn ->
      Eval.eval(expr)
    end) == """
    Hi
    Ok
    """
  end
end

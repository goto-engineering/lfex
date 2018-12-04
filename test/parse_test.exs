defmodule ParseTest do
  use ExUnit.Case

  test "#parse" do
    code = """
    (* 2 (+ 3 4))
    """
    assert Parse.parse(code) == [:__call__, :*, 2, [:__call__, :+, 3, 4]]
  end

  test "parses lists, numbers, strings, atoms" do
    code = """
    [1 2 3 "Bob" :alice]
    """
    assert Parse.parse(code) == [1, 2, 3, "Bob", :alice]
  end

  # test "tuples" do
  # end

  test "parses Module.function calls" do
    code = """
    (IO.puts "Hello world!")
    """
    assert Parse.parse(code) == [:__call__, :"IO.puts", "Hello world!"]
  end
end

defmodule ParseTest do
  use ExUnit.Case

  test "#tokenize" do
    code = """
    (* 2 (+ 3 4))
    """
    assert Parse.tokenize(code) == ["(", "*", "2", "(", "+", "3", "4", ")", ")"]
  end

  test "#parse" do
    code = """
    (* 2 (+ 3 4))
    """
    assert Parse.parse(code) == [:*, 2, [:+, 3, 4]]
  end

  test "parses lists, numbers, strings, atoms" do
    code = """
    [1 2 3 "Bob" :alice]
    """
    assert Parse.parse(code) == [1, 2, 3, "Bob", :alice]
  end
end

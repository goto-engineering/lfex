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

  test "parses dashes and underscores" do
    assert Parse.parse("[:rutherford-b-hayes]") == [:"rutherford-b-hayes"]
    assert Parse.parse("[:franklin_delano_roosevelt]") == [:franklin_delano_roosevelt]
  end

  test "parses tuples" do
    assert Parse.parse("{:name 2}") == {:name, 2}
  end

  test "parses Module.function calls" do
    code = """
    (IO.puts "Hello world!")
    """
    assert Parse.parse(code) == [:__call__, :"IO.puts", "Hello world!"]
  end

  test "parses Module.function calls with underscores" do
    code = """
    (String.to_integer "666")
    """
    assert Parse.parse(code) == [:__call__, :"String.to_integer", "666"]
  end
end

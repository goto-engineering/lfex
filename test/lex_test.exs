defmodule LexTest do
  use ExUnit.Case
  doctest Lex

  test "lexs empty list" do
    assert Lex.lex("()") == ["(", ")"]
  end

  test "lexs list with spaces" do
    assert Lex.lex("(   )") == ["(", ")"]
  end

  test "commas count as whitespace" do
    assert Lex.lex("(, ,, )") == ["(", ")"]
  end

  test "lexs empty strings" do
    assert Lex.lex(~s("")) == [~s("")]
  end

  test "lexs strings with spaces" do
    assert Lex.lex(~s("Alice and Bob ")) == [~s("Alice and Bob ")]
  end

  test "lex things after strings" do
    code = """
    (:atom "Bob" 4 :jane)
    """
    assert Lex.lex(code) == ["(", ":atom", ~s("Bob"), "4", ":jane", ")"]
  end

  test "lexs atoms" do
    assert Lex.lex(":adam") == [":adam"]
  end

  test "lexs integers" do
    assert Lex.lex("555") == ["555"]
  end

  test "lexs floats" do
    assert Lex.lex("5.55") == ["5.55"]
  end

  test "lexs operators as atoms" do
    assert Lex.lex("*") == ["*"]
  end

  test "lexs function names as atoms" do
    assert Lex.lex("IO.puts") == ["IO.puts"]
  end

  test "ignores comments" do
    assert Lex.lex("; Hello World") == []
  end

  test "lists []" do
    assert Lex.lex("[]") == ["[", "]"]
    assert Lex.lex("[   ]") == ["[", "]"]
    assert Lex.lex(~s([1 :alice "Bob" 5.55])) == ["[", "1", ":alice", ~s("Bob"), "5.55", "]"]
    assert Lex.lex(~s([1, :alice, "Bob", 5.55])) == ["[", "1", ":alice", ~s("Bob"), "5.55", "]"]
    assert Lex.lex("[[:alice :bob] [3]]") == ["[", "[", ":alice", ":bob", "]", "[", "3", "]", "]"]
  end

  test "tuples" do
    assert Lex.lex("{}") == ["{", "}"]
    assert Lex.lex("{   }") == ["{", "}"]
    assert Lex.lex(~s({1 :alice "Bob" 5.55})) == ["{", "1", ":alice", ~s("Bob"), "5.55", "}"]
  end

  test "lexs lists with things in them" do
    assert Lex.lex("(* 2 2)") == ["(", "*", "2", "2", ")"]
  end

  test "lexs numbers and operators in nested lists" do
    code = "(* 2 (+ 3 4))"
    assert Lex.lex(code) == ["(", "*", "2", "(", "+", "3", "4", ")", ")"]
  end

  test "ignores comments within code" do
    code = """
    (* 2 
    ; math goes here 
      (+ 3 4))
    """
    assert Lex.lex(code) == ["(", "*", "2", "(", "+", "3", "4", ")", ")"]
  end

  test "lexs strings with spaces in lists" do
    code = """
    (IO.puts " and ")
    """
    assert Lex.lex(code) == ["(", "IO.puts", ~s(" and "), ")"]
  end
end

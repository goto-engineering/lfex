defmodule LexTest do
  use ExUnit.Case
  doctest Lex

  test "lexes empty list" do
    assert Lex.lex("()") == ["(", ")"]
  end

  test "lexes list with spaces" do
    assert Lex.lex("(   )") == ["(", ")"]
  end

  test "commas count as whitespace" do
    assert Lex.lex("(, ,, )") == ["(", ")"]
  end

  test "lexes empty strings" do
    assert Lex.lex(~s("")) == [~s("")]
  end

  test "lexes strings with spaces" do
    assert Lex.lex(~s("Alice and Bob ")) == [~s("Alice and Bob ")]
  end

  test "lex things after strings" do
    code = """
    (:atom "Bob" 4 :jane)
    """
    assert Lex.lex(code) == ["(", ":atom", ~s("Bob"), "4", ":jane", ")"]
  end

  test "lexes atoms" do
    assert Lex.lex(":eve") == [":eve"]
  end

  test "lexes integers" do
    assert Lex.lex("555") == ["555"]
  end

  test "lexes floats" do
    assert Lex.lex("5.55") == ["5.55"]
  end

  test "lexes operators" do
    assert Lex.lex("*") == ["*"]
  end

  test "lexes function names" do
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

  test "lexes lists with things in them" do
    assert Lex.lex("(* 2 2)") == ["(", "*", "2", "2", ")"]
  end

  test "lexes numbers and operators in nested lists" do
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

  test "lexes strings with spaces in lists" do
    code = """
    (IO.puts " and ")
    """
    assert Lex.lex(code) == ["(", "IO.puts", ~s(" and "), ")"]
  end

  test "lexes symbol before line break" do
    code = """
    :luthor
    """
    assert Lex.lex(code) == [":luthor"]
  end
end

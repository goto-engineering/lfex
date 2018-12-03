defmodule TokenizerTest do
  use ExUnit.Case
  doctest Tokenizer

  test "tokenizes empty list" do
    assert Tokenizer.tokenize("()") == ["(", ")"]
  end

  test "tokenizes list with spaces" do
    assert Tokenizer.tokenize("(   )") == ["(", ")"]
  end

  test "tokenizes empty strings" do
    assert Tokenizer.tokenize(~s("")) == [""]
  end

  test "tokenizes strings with spaces" do
    assert Tokenizer.tokenize(~s("Alice and Bob ")) == ["Alice and Bob "]
  end

  test "tokenizes atoms" do
    assert Tokenizer.tokenize(":adam") == [":adam"]
  end

  test "tokenizes integers" do
    assert Tokenizer.tokenize("555") == ["555"]
  end

  test "tokenizes floats" do
    assert Tokenizer.tokenize("5.55") == ["5.55"]
  end

  test "tokenizes operators as atoms" do
    assert Tokenizer.tokenize("*") == ["*"]
  end

  test "tokenizes function names as atoms" do
    assert Tokenizer.tokenize("IO.puts") == ["IO.puts"]
  end

  test "ignores comments" do
    assert Tokenizer.tokenize("; Hello World") == []
  end

  # test "lists []"
  # test "tuples"

  test "tokenizes lists with things in them" do
    assert Tokenizer.tokenize("(* 2 2)") == ["(", "*", "2", "2", ")"]
  end

  test "tokenizes numbers and operators in nested lists" do
    code = "(* 2 (+ 3 4))"
    assert Tokenizer.tokenize(code) == ["(", "*", "2", "(", "+", "3", "4", ")", ")"]
  end

  test "ignores comments within code" do
    code = """
    (* 2 
    ; math goes here 
      (+ 3 4))
    """
    assert Tokenizer.tokenize(code) == ["(", "*", "2", "(", "+", "3", "4", ")", ")"]
  end

  # test "tokenizes strings with spaces in lists" do
  #   code = """
  #   (IO.puts " and ")
  #   """
  #   assert Tokenizer.tokenize(code) == ["(", "IO.puts", ~s(" and "), ")"]
  # end
end

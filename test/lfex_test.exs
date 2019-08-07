defmodule LfexTest do
  use ExUnit.Case

  test "#interpret" do
    program = """
    (* 999 999)
    """
    assert Lfex.interpret(program) == 998001
  end

  test "#to_lfex_string" do
    assert Lfex.to_lfex_string(123) == "123"
    assert Lfex.to_lfex_string([1, :b, "Charlie"]) == ~s([1 :b "Charlie"])
    assert Lfex.to_lfex_string(%{john: :doe}) == "%{:john :doe}"
    assert Lfex.to_lfex_string({:error, "All your friends are dead"}) == "Error: All your friends are dead"
  end

  test "errors" do
    not_math = """
    (+ 1 "2")
    """
    assert Lfex.interpret(not_math) == {:error, "bad argument in arithmetic expression"}

    not_lisp = """
    1+1
    """
    assert Lfex.interpret(not_lisp) == {:error, ~s/Invalid term "{1, "+1"}"/}
  end
end

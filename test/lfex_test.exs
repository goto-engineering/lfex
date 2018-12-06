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
  end
end

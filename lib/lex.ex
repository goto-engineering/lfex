defmodule Lex do
  @moduledoc """
  Splits Lisp code into string tokens

  ## Example
  
     iex(1)> Lex.lex("(* 2 (+ 3 4))")
     ["(", "*", "2", "(", "+", "3", "4", ")", ")"]
  """

  import Common

  def lex(string) do
    string
    |> lex([], "")
  end

  defp lex("", acc, symbol_acc) do
    Enum.reverse(add_symbol_unless_empty(acc, symbol_acc))
  end

  defp lex(~s(") <> rest, acc, _) do
    lex_string(rest, acc, ~s("))
  end

  defp lex(";" <> rest, acc, _) do
    lex_comment(rest, acc)
  end

  defp lex(" " <> rest, acc, "") do
    lex(rest, acc, "")
  end

  defp lex(" " <> rest, acc, symbol_acc) do
    lex(rest, [symbol_acc | acc], "")
  end

  defp lex("," <> rest, acc, symbol_acc) do
    lex(rest, acc, symbol_acc)
  end

  defp lex("\n" <> rest, acc, "") do
    lex(rest, acc, "")
  end

  defp lex("\n" <> rest, acc, symbol_acc) do
    lex(rest, [symbol_acc | acc], "")
  end

  defp lex("%{" <> rest, acc, symbol_acc) do
    lex(rest, ["%{" | acc], symbol_acc)
  end

  @open_delimiters ["(", "[", "{"]
  @close_delimiters [")", "]", "}"]

  defp lex(x, acc, symbol_acc) do
    char = String.first(x)
    rest = drop_first(x)

    cond do
      Enum.member?(@open_delimiters, char) ->
        lex(rest, [char | acc], "")
      Enum.member?(@close_delimiters, char) ->
        lex(rest, [char| add_symbol_unless_empty(acc, symbol_acc)], "")
      true ->
        lex(rest, acc, symbol_acc <> char)
    end
  end

  defp add_symbol_unless_empty(acc, "") do
    acc
  end

  defp add_symbol_unless_empty(acc, symbol_acc) do
    [symbol_acc | acc]
  end

  defp lex_comment("\n" <> rest, acc) do
    lex(rest, acc, "")
  end

  defp lex_comment("", acc) do
    lex("", acc, "")
  end

  defp lex_comment(x, acc) do
    lex_comment(drop_first(x), acc)
  end

  defp lex_string(~s(") <> rest, acc, string_acc) do
    lex(rest, [string_acc <> ~s(") | acc], "")
  end

  defp lex_string(x, acc, string_acc) do
    lex_string(drop_first(x), acc, string_acc <> String.first(x)) 
  end
end

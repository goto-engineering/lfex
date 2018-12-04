defmodule Lex do
  @moduledoc """
  Splits Lisp code into string tokens

  ## Example
  
     iex(1)> Lex.lex("(* 2 (+ 3 4))")
     ["(", "*", "2", "(", "+", "3", "4", ")", ")"]
  """

  def lex(string) do
    string
    |> String.trim
    |> String.replace(",", "")
    |> lex([])
    |> List.flatten
  end

  defp lex("\n" <> rest, acc), do: lex(rest, acc)
  defp lex(" " <> rest, acc), do: lex(rest, acc) 
  defp lex(";" <> rest, acc), do: lex_comment(rest, acc)

  defp lex(~s(") <> rest, acc), do: lex_string(rest, ~s("), acc)

  defp lex("(" <> rest, acc), do: lex(rest, ["(" | acc])
  defp lex(")" <> rest, acc), do: lex(rest, [")" | acc])
  defp lex("[" <> rest, acc), do: lex(rest, ["[" | acc])
  defp lex("]" <> rest, acc), do: lex(rest, ["]" | acc])
  defp lex("{" <> rest, acc), do: lex(rest, ["{" | acc])
  defp lex("}" <> rest, acc), do: lex(rest, ["}" | acc])

  defp lex("", acc), do: Enum.reverse(acc)

  defp lex(x, acc) do
    case String.contains?(x, " ") do
      true -> [token, rest] = String.split(x, " ", parts: 2)
        lex(rest, [token | acc])
      false -> lex_stuffs(x, acc)
    end
  end

  defp lex_stuffs(x, acc) do
    handle_primitives = fn y, f -> [y, f] end

    handle_brackets = fn y, z -> 
      handle_end_delimiter(y, "]", z, handle_primitives)
    end

    handle_tuples = fn y, z ->
      handle_end_delimiter(y, "}", z, handle_brackets)
    end

    handle_end_delimiter(x, ")", acc, handle_tuples)
  end

  defp handle_end_delimiter(x, delimiter, acc, then_fn) do
    case String.ends_with?(x, delimiter) do
      true -> remainder = remove_last_char(x)
        lexd_remainder = lex(remainder, [])
        lex(delimiter, [lexd_remainder | acc])
      false -> then_fn.(x, acc)
    end
  end

  defp lex_string(~s(") <> rest, str_acc, acc), do: lex(rest, [str_acc <> ~s(") | acc])
  defp lex_string(string, str_acc, acc) do
    lex_string(remove_first_char(string), str_acc <> String.first(string), acc)
  end

  defp lex_comment("\n" <> rest, acc), do: lex(rest, acc)
  defp lex_comment("", acc), do: acc
  defp lex_comment(comment, acc), do: lex_comment(remove_first_char(comment), acc)

  defp remove_first_char(string), do: String.slice(string, 1..-1)
  defp remove_last_char(string), do: String.slice(string, 0..-2)
end

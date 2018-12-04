defmodule Tokenizer do
  @moduledoc """
  Tokenizes Lisp code into string tokens

  ## Example
  
     iex(1)> Tokenizer.tokenize("(* 2 (+ 3 4))")
     ["(", "*", "2", "(", "+", "3", "4", ")", ")"]
  """

  def tokenize(string) do
    string
    |> String.trim
    |> String.replace(",", "")
    |> tokenize([])
    |> List.flatten
  end

  defp tokenize("\n" <> rest, acc), do: tokenize(rest, acc)
  defp tokenize(" " <> rest, acc), do: tokenize(rest, acc) 
  defp tokenize(";" <> rest, acc), do: tokenize_comment(rest, acc)

  defp tokenize(~s(") <> rest, acc), do: tokenize_string(rest, "", acc)

  defp tokenize("(" <> rest, acc), do: tokenize(rest, ["(" | acc])
  defp tokenize(")" <> rest, acc), do: tokenize(rest, [")" | acc])
  defp tokenize("[" <> rest, acc), do: tokenize(rest, ["[" | acc])
  defp tokenize("]" <> rest, acc), do: tokenize(rest, ["]" | acc])
  defp tokenize("{" <> rest, acc), do: tokenize(rest, ["{" | acc])
  defp tokenize("}" <> rest, acc), do: tokenize(rest, ["}" | acc])

  defp tokenize("", acc), do: Enum.reverse(acc)

  defp tokenize(x, acc) do
    case String.contains?(x, " ") do
      true -> [token, rest] = String.split(x, " ", parts: 2)
        tokenize(rest, [token | acc])
      false -> tokenize_stuffs(x, acc)
    end
  end

  defp tokenize_stuffs(x, acc) do
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
        tokenized_remainder = tokenize(remainder, [])
        tokenize(delimiter, [tokenized_remainder | acc])
      false -> then_fn.(x, acc)
    end
  end

  defp tokenize_string(~s(") <> rest, str_acc, acc), do: tokenize(rest, [str_acc | acc])
  defp tokenize_string(string, str_acc, acc) do
    tokenize_string(remove_first_char(string), str_acc <> String.first(string), acc)
  end

  defp tokenize_comment("\n" <> rest, acc), do: tokenize(rest, acc)
  defp tokenize_comment("", acc), do: acc
  defp tokenize_comment(comment, acc), do: tokenize_comment(remove_first_char(comment), acc)

  defp remove_first_char(string), do: String.slice(string, 1..-1)
  defp remove_last_char(string), do: String.slice(string, 0..-2)
end

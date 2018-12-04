defmodule Parse do
  def parse(program) do
    program
    |> Lex.lex
    |> parse([])
    |> hd
  end

  defp parse(["(" | tail], acc) do
    {rem_tokens, sub_tree} = parse(tail, [])
    parse(rem_tokens, [sub_tree | acc])
  end

  defp parse([")" | tail], acc) do
    {tail, Enum.reverse(acc)}
  end

  defp parse(["[" | tail], acc) do
    {rem_tokens, sub_tree} = parse(tail, [])
    parse(rem_tokens, [sub_tree | acc])
  end

  defp parse(["]" | tail], acc) do
    {tail, Enum.reverse(acc)}
  end

  defp parse([], acc) do
    Enum.reverse(acc)
  end

  defp parse([head | tail], acc) do
    parse(tail, [typecast(head) | acc])
  end

  defp typecast(token) do
    case Integer.parse(token) do
      {value, ""} ->
        value

      :error ->
        case Float.parse(token) do
          {value, ""} -> value
          :error -> string_or_atom(token)
        end
    end
  end

  # TODO: extract slice from tokenizer and share
  defp string_or_atom(~s(") <> token), do: String.slice(token, 0..-2)
  defp string_or_atom(":" <> token), do: String.to_atom(token)
  defp string_or_atom(token), do: String.to_atom(token)
end

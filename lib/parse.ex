defmodule Parse do
  def parse(program) do
    program
    |> Tokenizer.tokenize
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

  def typecast(token) do
    case Integer.parse(token) do
      {value, ""} ->
        value

      :error ->
        case Float.parse(token) do
          {value, ""} -> value
          :error -> String.to_atom(token)
        end
    end
  end
end

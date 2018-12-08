defmodule Parse do
  def parse(program) do
    program
    |> Lex.lex
    |> parse([])
    |> flatten_if_trivial
  end

  defp parse(tail, acc, in_map \\ false)

  defp parse(["(" | tail], acc, in_map) do
    {rem_tokens, sub_tree} = parse(tail, [])
    parse(rem_tokens, [[:__call__ | sub_tree] | acc], in_map)
  end

  defp parse([")" | tail], acc, _), do: {tail, Enum.reverse(acc)}

  defp parse(["[" | tail], acc, in_map) do
    {rem_tokens, sub_tree} = parse(tail, [])
    parse(rem_tokens, [sub_tree | acc], in_map)
  end

  defp parse(["]" | tail], acc, _) do
    {tail, Enum.reverse(acc)}
  end

  defp parse(["{" | tail], acc, in_map) do
    {rem_tokens, sub_tree} = parse(tail, [])
    parse(rem_tokens, [sub_tree | acc], in_map)
  end

  defp parse(["%{" | tail], acc, _) do
    {rem_tokens, sub_tree} = parse(tail, [], true)
    parse(rem_tokens, [sub_tree | acc], false)
  end

  defp parse(["}" | tail], acc, false) do
    {tail, acc |> Enum.reverse |> List.to_tuple}
  end

  defp parse(["}" | tail], acc, true) do
    map = acc
          |> Enum.reverse
          |> Enum.chunk_every(2)
          |> Map.new(fn [k, v] -> {k, v} end)
    {tail, map}
  end

  defp parse([], acc, _) when is_list(acc), do: Enum.reverse(acc)

  defp parse([head | tail], acc, in_map) when is_list(acc) do
    parse(tail, [typecast(head) | acc], in_map)
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

  defp string_or_atom(~s(") <> token), do: Common.drop_last(token)
  defp string_or_atom(":" <> token), do: String.to_atom(token)
  defp string_or_atom(token), do: String.to_atom(token)

  defp flatten_if_trivial([expr]) when is_tuple(expr), do: expr
  defp flatten_if_trivial([expr]) when is_map(expr), do: expr
  defp flatten_if_trivial([expr]) when is_list(expr), do: expr
  defp flatten_if_trivial(expr), do: expr
end

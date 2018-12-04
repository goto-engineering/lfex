defmodule Parse do
  def parse(program) do
    program
    |> Lex.lex
    |> parse([])
    |> hd
  end

  defp parse(["(" | tail], acc) do
    {rem_tokens, sub_tree} = parse(tail, [])
    parse(rem_tokens, [[:__call__ | sub_tree] | acc])
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

  defp parse(["{" | tail], acc) do
    {rem_tokens, sub_tree} = parse(tail, [])
    parse(rem_tokens, [sub_tree | acc])
  end

  defp parse(["}" | tail], acc) do
    {tail, acc |> Enum.reverse |> List.to_tuple}
  end

  defp parse([], acc) when is_list(acc), do: Enum.reverse(acc)
  defp parse([], acc) when is_tuple(acc), do: [acc]

  defp parse([head | tail], acc) when is_list(acc) do
    parse(tail, [typecast(head) | acc])
  end

  defp parse([head | tail], acc) when is_tuple(acc) do
    parse(tail, Tuple.append(acc, typecast(head)))
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
end

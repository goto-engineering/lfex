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

    module_scoped? = elem(sub_tree, 0)
                  |> Atom.to_string
                  |> String.contains?(".")

    new_tree = 
      case module_scoped? do
        true -> to_module_ast(sub_tree)
        false -> to_kernel_ast(sub_tree)
      end

    parse(rem_tokens, [List.to_tuple(new_tree) | acc], in_map)
  end

  defp parse([")" | tail], acc, _), do: {tail, Enum.reverse(acc) |> List.to_tuple}

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
    parse(rem_tokens, [sub_tree | acc], true)
  end

  defp parse(["}" | tail], acc, false) do
    {tail, {:{}, [], acc |> Enum.reverse}}
  end

  defp parse(["}" | tail], acc, true) do
    map = acc
          |> Enum.chunk_every(2)
          |> Enum.map(&Enum.reverse/1)
          |> Enum.map(&List.to_tuple/1)
          |> Enum.reverse
    map_ast = {:%{}, [], map}
    {tail, map_ast}
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

  defp to_kernel_ast(sub_tree) do
    [fun | args] = Tuple.to_list(sub_tree)
    [fun, [], args]
  end

  defp to_module_ast(sub_tree) do
    [module_atom, fn_atom] = elem(sub_tree, 0)
                             |> Atom.to_string
                             |> String.split(".")
                             |> Enum.map(&String.to_atom/1)
    [_ | args] = sub_tree |> Tuple.to_list
    [{:., [], [{:__aliases__, [], [module_atom]}, fn_atom]}, [], args]
  end

  defp string_or_atom(~s(") <> token), do: Common.drop_last(token)
  defp string_or_atom(":" <> token), do: String.to_atom(token)
  defp string_or_atom(token), do: String.to_atom(token)

  defp flatten_if_trivial([expr]) when is_tuple(expr), do: expr
  defp flatten_if_trivial([expr]) when is_map(expr), do: expr
  defp flatten_if_trivial([expr]) when is_list(expr), do: expr
  defp flatten_if_trivial(expr), do: {:__block__, [], expr}
end

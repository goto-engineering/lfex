defmodule Eval do
  def eval(expr) when is_list(expr), do: eval(expr, [])
  def eval(expr), do: expr

  defp eval([], acc), do: Enum.reverse(acc)

  defp eval([:__call__ | expr], acc) do
    {module, function} =
      case hd(expr) |> to_string |> String.split(".") do
        [operator] -> {"Kernel", operator}
        [module, function] -> {module, function}
      end
    module = String.to_existing_atom("Elixir." <> module)
    function = String.to_existing_atom(function)

    args = tl(expr)

    args = case Enum.any?(args, fn x -> is_list(x) end) do
      true -> eval(args)
      false -> args
    end

    apply(module, function, args)
  end

  defp eval([head | expr], acc) when is_list(head) do
    eval(expr, [eval(head) | acc])
  end

  defp eval([head | expr], acc) do
    eval(expr, [head | acc])
  end

  defp eval(expr, acc) do
    eval([], [expr | acc])
  end
end

defmodule Eval do
  def eval(x) when is_list(x) do
    {module, function} =
      case hd(x) |> to_string |> String.split(".") do
        [operator] -> {"Kernel", operator}
        [module, function] -> {module, function}
      end

    args = tl(x)

    module = String.to_existing_atom("Elixir." <> module)
    function = String.to_existing_atom(function)
    apply(module, function, args)
  end

  def eval(x), do: x
end

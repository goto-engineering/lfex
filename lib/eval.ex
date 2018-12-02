defmodule Eval do
  def eval(x) when is_list(x) do
    [module, function] = hd(x) |> to_string |> String.split(".")
    args = tl(x)

    apply(String.to_existing_atom("Elixir." <> module), String.to_existing_atom(function), args)
  end

  def eval(x), do: x
end

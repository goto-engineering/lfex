defmodule Common do
  def drop_first(string), do: String.slice(string, 1..-1)
  def drop_last(string), do: String.slice(string, 0..-2)
end

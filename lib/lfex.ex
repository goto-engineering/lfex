defmodule Lfex do
  def interpret(program) do
    try do
      program
      |> Parse.parse
      |> Eval.eval
    rescue
      e in CaseClauseError -> {:error, ~s/Invalid term "#{Kernel.inspect(e.term)}"/}
      e -> {:error, e.message}
    end
  end

  def to_lfex_string(expr) when is_atom(expr), do: ":#{expr}"
  def to_lfex_string(expr) when is_binary(expr), do: ~s("#{expr}")

  def to_lfex_string(expr) when is_list(expr) do
    string = expr
             |> Enum.map(&to_lfex_string/1)
             |> Enum.join(" ")
    "[#{string}]"
  end

  def to_lfex_string(expr) when is_map(expr) do
    string = expr
             |> Map.to_list
             |> Enum.map(fn t -> Tuple.to_list(t) end)
             |> List.flatten
             |> Enum.map(&to_lfex_string/1)
             |> Enum.join(" ")
    "%{#{string}}"
  end

  def to_lfex_string({:error, message}), do: "Error: #{message}"

  def to_lfex_string(expr), do: to_string(expr)

  def repl do
    program = IO.gets "lfex> "
    result = program |> interpret()

    # try do
      result |> to_lfex_string |> IO.puts
    # rescue
    #   e ->
    #     IO.inspect e
    #     IO.puts "Print error: #{}"
    #     IO.inspect result
    # end

    repl()
  end
end

defmodule Mix.Tasks.Day do
  use Mix.Task

  @shortdoc "Run the script for a day's challenges"

  def run(args) do
    args
    |> List.first()
    |> String.pad_leading(2, "0")
    |> (&"Elixir.Day#{&1}").()
    |> String.to_atom()
    |> apply(:execute, [])
  end
end

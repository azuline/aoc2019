defmodule Day18 do
  @moduledoc """
  Advent of Code 2019
  Day 18: Many-Worlds Interpretation

  """

  alias Day18.{Part1, Part2}

  def get_vault() do
    Path.join(__DIR__, "inputs/day18.txt")
    |> File.read!()
    |> String.trim()
  end

  def execute() do
    vault = get_vault()

    IO.puts("Part 1: #{Part1.run(vault)}")
    IO.puts("Part 2: #{Part2.run(vault)}")
  end
end

defmodule Day18.Part1 do
  def run(vault) do
    vault
  end
end

defmodule Day18.Part2 do
  def run(vault) do
    vault
  end
end

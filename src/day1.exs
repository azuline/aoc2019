defmodule Day1 do
  @moduledoc """
  Advent of Code 2019
  Day 1: The Tyranny of the Rocket Equation

  $ elixir day1.exs input/day1.txt
  """

  def part1() do
    runner(&calculate_fuel_part_1/1)
  end

  def part2() do
    runner(&calculate_fuel_part_2/1)
  end

  defp runner(calculate_fuel) do
    get_masses()
    |> Stream.map(calculate_fuel)
    |> Enum.sum()
    |> IO.puts()
  end

  defp get_masses() do
    case System.argv() do
      [filepath] ->
        File.open!(filepath)
        |> IO.stream(:line)
        |> Stream.map(&String.trim/1)
        |> Stream.map(&String.to_integer/1)

      _ ->
        IO.puts("Pass a file containing the inputs as an argument.")
        System.halt(1)
    end
  end

  defp calculate_fuel_part_1(mass) do
    trunc(mass / 3) - 2
  end

  defp calculate_fuel_part_2(mass) do
    case calculate_fuel_part_1(mass) do
      fuel when fuel > 0 -> fuel + calculate_fuel_part_2(fuel)
      _ -> 0
    end
  end
end

IO.puts("Part 1:")
Day1.part1()

IO.puts("\nPart 2:")
Day1.part2()

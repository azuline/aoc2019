defmodule Day1 do
  @moduledoc """
  Advent of Code 2019
  Day 1: The Tyranny of the Rocket Equation

  $ elixir day1.exs input/day1.txt
  """

  def part1() do
    runner(&fuel_of_mass_calculator/1)
  end

  def part2() do
    runner(&fuel_of_fuel_calculator/1)
  end

  defp fuel_of_mass_calculator(mass) do
    trunc(mass / 3) - 2
  end

  defp fuel_of_fuel_calculator(mass) do
    case fuel_of_mass_calculator(mass) do
      fuel when fuel > 0 -> fuel + fuel_of_fuel_calculator(fuel)
      _ -> 0
    end
  end

  defp runner(calculate_fuel) do
    get_masses()
    |> Stream.map(calculate_fuel)
    |> Enum.sum()
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
end

part1 = Day1.part1()
IO.puts("Part 1: #{part1}")

part2 = Day1.part2()
IO.puts("Part 2: #{part2}")

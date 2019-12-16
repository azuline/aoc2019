defmodule Day01 do
  @moduledoc """
  Advent of Code 2019
  Day 1: The Tyranny of the Rocket Equation
  """

  def get_masses() do
    Path.join(__DIR__, "inputs/day01.txt")
    |> File.open!()
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def execute() do
    masses = get_masses()

    IO.puts("Part 1: #{part1(masses)}")
    IO.puts("Part 2: #{part2(masses)}")
  end

  def part1(masses), do: runner(masses, &fuel_of_mass_calculator/1)
  def part2(masses), do: runner(masses, &fuel_of_fuel_calculator/1)

  def runner(masses, calculate_fuel) do
    masses
    |> Stream.map(calculate_fuel)
    |> Enum.sum()
  end

  def fuel_of_mass_calculator(mass) do
    div(mass, 3) - 2
  end

  def fuel_of_fuel_calculator(mass) do
    case fuel_of_mass_calculator(mass) do
      fuel when fuel <= 0 -> 0
      fuel -> fuel + fuel_of_fuel_calculator(fuel)
    end
  end
end

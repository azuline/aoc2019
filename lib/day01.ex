defmodule Day01 do
  @moduledoc """
  Advent of Code 2019
  Day 1: The Tyranny of the Rocket Equation
  """

  alias Day01.{Part1, Part2}

  def get_masses() do
    Path.join(__DIR__, "inputs/day01.txt")
    |> File.open!()
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

  def execute() do
    masses = get_masses()

    IO.puts("Part 1: #{Part1.run(masses)}")
    IO.puts("Part 2: #{Part2.run(masses)}")
  end
end

defmodule Day01.Part1 do
  def run(masses) do
    Stream.map(masses, &calculate_fuel/1)
    |> Enum.sum()
  end

  def calculate_fuel(mass) do
    div(mass, 3) - 2
  end
end

defmodule Day01.Part2 do
  alias Day01.Part1

  def run(masses) do
    Stream.map(masses, &calculate_fuel/1)
    |> Enum.sum()
  end

  def calculate_fuel(mass) do
    case Part1.calculate_fuel(mass) do
      fuel when fuel <= 0 -> 0
      fuel -> fuel + calculate_fuel(fuel)
    end
  end
end

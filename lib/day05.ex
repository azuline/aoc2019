defmodule Day05 do
  @moduledoc """
  Advent of Code 2019
  Day 5: Sunny with a Chance of Asteroids
  """

  alias Day05.{Part1, Part2}

  def get_program() do
    Path.join(__DIR__, "inputs/day05.txt")
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def execute() do
    program = get_program()

    IO.puts("Part 1: #{Part1.run(program)}")
    IO.puts("Part 2: #{Part2.run(program)}")
  end
end

defmodule Day05.Part1 do
  import Intcode, only: [run_computer: 2]

  def run(program) do
    GenServer.start_link(Intcode, program, name: Computer)
    output = run_computer(Computer, [1])
    GenServer.stop(Computer)
    output
  end
end

defmodule Day05.Part2 do
  import Intcode, only: [run_computer: 2]

  def run(program) do
    GenServer.start_link(Intcode, program, name: Computer)
    output = run_computer(Computer, [5])
    GenServer.stop(Computer)
    output
  end
end

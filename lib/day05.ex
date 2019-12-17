defmodule Day05 do
  @moduledoc """
  Advent of Code 2019
  Day 5: Sunny with a Chance of Asteroids
  """

  import IntCode, only: [run_computer: 2]

  def get_program() do
    Path.join(__DIR__, "inputs/day05.txt")
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def execute() do
    program = get_program()

    IO.puts("Part 1: #{part1(program)}")
    IO.puts("Part 2: #{part2(program)}")
  end

  def part1(program) do
    GenServer.start_link(IntCode, program, name: Computer)
    output = run_computer(Computer, [1])
    GenServer.stop(Computer)
    output
  end

  def part2(program) do
    GenServer.start_link(IntCode, program, name: Computer)
    output = run_computer(Computer, [5])
    GenServer.stop(Computer)
    output
  end
end
defmodule Day7 do
  @moduledoc """
  Advent of Code 2019
  Day 7: Amplification Circuit
  """

  import Day5, only: [run_program: 2]

  def get_program() do
    Path.join(__DIR__, "inputs/day7.txt")
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def execute() do
    program = get_program()

    IO.puts("Part 1: #{part1(program)}")
  end

  def part1(program) do
    get_permutations([0, 1, 2, 3, 4])
    |> Enum.map(fn [a, b, c, d, e] ->
      run_program(program, [a, 0])
      |> (&run_program(program, [b, &1])).()
      |> (&run_program(program, [c, &1])).()
      |> (&run_program(program, [d, &1])).()
      |> (&run_program(program, [e, &1])).()
      |> (&{"#{a}#{b}#{c}#{d}#{e}", &1}).()
    end)
    |> Enum.max_by(&elem(&1, 1))
    |> (&"Max thruster signal #{elem(&1, 1)} from sequence #{elem(&1, 0)}").()
  end

  def get_permutations(elements) do
    get_permutations(elements, length(elements))
  end

  def get_permutations(_elements, 0 = _ctr) do
    [[]]
  end

  def get_permutations(elements, ctr) do
    for e <- elements, body <- get_permutations(elements -- [e], ctr - 1), do: [e | body]
  end
end

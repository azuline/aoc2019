defmodule Day07 do
  @moduledoc """
  Advent of Code 2019
  Day 7: Amplification Circuit
  """

  alias Day07.{Part1, Part2}

  def get_program() do
    Path.join(__DIR__, "inputs/day07.txt")
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

defmodule Day07.Part1 do
  alias Day07.Combinatorics
  import Intcode, only: [run_computer: 2]

  def run(program) do
    Combinatorics.get_permutations([0, 1, 2, 3, 4])
    |> Enum.map(&{&1, run_series(program, &1)})
    |> Enum.max_by(&elem(&1, 1))
    |> format_result()
  end

  def run_series(program, sequence) do
    start_computers(program)

    output =
      run_computer(:Computer070, [Enum.at(sequence, 0), 0])
      |> (&run_computer(:Computer071, [Enum.at(sequence, 1), &1])).()
      |> (&run_computer(:Computer072, [Enum.at(sequence, 2), &1])).()
      |> (&run_computer(:Computer073, [Enum.at(sequence, 3), &1])).()
      |> (&run_computer(:Computer074, [Enum.at(sequence, 4), &1])).()

    stop_computers()
    output
  end

  def format_result({[a, b, c, d, e], signal}) do
    "Max thruster signal #{signal} from sequence #{a}#{b}#{c}#{d}#{e}"
  end

  def start_computers(program) do
    for i <- 0..4,
        do: GenServer.start_link(Intcode, program, name: String.to_atom("Computer07#{i}"))
  end

  def stop_computers() do
    for i <- 0..4, do: GenServer.stop(String.to_atom("Computer07#{i}"))
  end
end

defmodule Day07.Part2 do
  alias Day07.{Part1, Combinatorics}

  def run(program) do
    Combinatorics.get_permutations([5, 6, 7, 8, 9])
    |> Enum.map(&{&1, run_feedback_loop(program, &1)})
    |> Enum.max_by(&elem(&1, 1))
    |> Part1.format_result()
  end

  def run_feedback_loop(program, sequence) do
    Part1.start_computers(program)

    output =
      initialize_computers(sequence)
      |> (&run_circuit_loop(program, &1)).()

    Part1.stop_computers()
    output
  end

  defp initialize_computers(sequence) do
    sequence
    |> Enum.with_index()
    |> Enum.reduce(0, fn {setting, i}, input ->
      GenServer.call(String.to_atom("Computer07#{i}"), {:run, [setting, input]})
      |> (&elem(&1, 1)).()
    end)
  end

  defp run_circuit_loop(program, input) do
    output =
      GenServer.call(:Computer070, {:run, [input]})
      |> (&GenServer.call(:Computer071, {:run, [elem(&1, 1)]})).()
      |> (&GenServer.call(:Computer072, {:run, [elem(&1, 1)]})).()
      |> (&GenServer.call(:Computer073, {:run, [elem(&1, 1)]})).()
      |> (&GenServer.call(:Computer074, {:run, [elem(&1, 1)]})).()

    case output do
      {:output, code} -> run_circuit_loop(program, code)
      {:exit, code} -> code
    end
  end
end

defmodule Day07.Combinatorics do
  def get_permutations([]), do: [[]]

  def get_permutations(elements) do
    for(e <- elements, body <- get_permutations(elements -- [e]), do: [e | body])
  end
end

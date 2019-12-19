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
  import IntCode, only: [run_computer: 2]

  def run(program) do
    Combinatorics.get_permutations([0, 1, 2, 3, 4])
    |> Enum.map(&{&1, run_series(program, &1)})
    |> Enum.max_by(&elem(&1, 1))
    |> format_result()
  end

  def run_series(program, sequence) do
    start_computers(program)

    output =
      run_computer(:Computer0, [Enum.at(sequence, 0), 0])
      |> (&run_computer(:Computer1, [Enum.at(sequence, 1), &1])).()
      |> (&run_computer(:Computer2, [Enum.at(sequence, 2), &1])).()
      |> (&run_computer(:Computer3, [Enum.at(sequence, 3), &1])).()
      |> (&run_computer(:Computer4, [Enum.at(sequence, 4), &1])).()

    stop_computers()
    output
  end

  def format_result({[a, b, c, d, e], signal}) do
    "Max thruster signal #{signal} from sequence #{a}#{b}#{c}#{d}#{e}"
  end

  def start_computers(program) do
    for i <- 0..4,
        do: GenServer.start_link(IntCode, program, name: String.to_atom("Computer#{i}"))
  end

  def stop_computers() do
    for i <- 0..4, do: GenServer.stop(String.to_atom("Computer#{i}"))
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
      GenServer.call(String.to_atom("Computer#{i}"), {:run, [setting, input]})
      |> (&elem(&1, 1)).()
    end)
  end

  defp run_circuit_loop(program, input) do
    output =
      GenServer.call(:Computer0, {:run, [input]})
      |> (&GenServer.call(:Computer1, {:run, [elem(&1, 1)]})).()
      |> (&GenServer.call(:Computer2, {:run, [elem(&1, 1)]})).()
      |> (&GenServer.call(:Computer3, {:run, [elem(&1, 1)]})).()
      |> (&GenServer.call(:Computer4, {:run, [elem(&1, 1)]})).()

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

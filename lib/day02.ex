defmodule Day02 do
  @moduledoc """
  Advent of Code 2019
  Day 2: 1202 Program Alarm
  """

  alias Day02.{Part1, Part2}

  def get_program() do
    Path.join(__DIR__, "inputs/day02.txt")
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

defmodule Day02.Part1 do
  def run(program) do
    program
    |> restore_state()
    |> run_program()
    |> List.first()
  end

  def restore_state(program, noun \\ 12, verb \\ 2) do
    program
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  def run_program(program, position \\ 0) do
    case Enum.at(program, position) do
      99 -> program
      opcode -> run_opcode(opcode, program, position)
    end
  end

  defp run_opcode(1, program, position) do
    program
    |> run_operation(position, &(&1 + &2))
    |> run_program(position + 4)
  end

  defp run_opcode(2, program, position) do
    program
    |> run_operation(position, &(&1 * &2))
    |> run_program(position + 4)
  end

  defp run_operation(program, position, operation) do
    arg1 = get_arg(program, position + 1)
    arg2 = get_arg(program, position + 2)
    result_index = Enum.at(program, position + 3)

    List.replace_at(program, result_index, operation.(arg1, arg2))
  end

  defp get_arg(program, position) do
    program
    |> Enum.at(position)
    |> (&Enum.at(program, &1)).()
  end
end

defmodule Day02.Part2 do
  alias Day02.Part1

  @target 19_690_720

  def run(program) do
    for(noun <- 0..100, verb <- 0..100, do: {noun, verb})
    |> Enum.find(nil, &valid_noun_verb?(program, &1))
    |> (fn {noun, verb} -> 100 * noun + verb end).()
  end

  def valid_noun_verb?(program, {noun, verb}) do
    program
    |> Part1.restore_state(noun, verb)
    |> Part1.run_program()
    |> List.first()
    |> (&(&1 == @target)).()
  end
end

defmodule Day2 do
  @moduledoc """
  Advent of Code 2019
  Day 2: 1202 Program Alarm

  $ elixir day2.exs input/day2.txt
  """

  def part1() do
    get_program()
    |> restore_state()
    |> run_program()
    |> List.first()
    |> IO.puts()
  end

  def part2() do
    program = get_program()

    for(noun <- 0..100, verb <- 0..100, do: {noun, verb})
    |> Enum.find(nil, &test_noun_verb(program, &1))
    |> (fn {noun, verb} -> 100 * noun + verb end).()
    |> IO.puts()
  end

  defp test_noun_verb(program, {noun, verb}) do
    program
    |> restore_state(noun, verb)
    |> run_program()
    |> List.first()
    |> (&(&1 == 19_690_720)).()
  end

  defp get_program() do
    case System.argv() do
      [filepath] ->
        File.read!(filepath)
        |> String.trim()
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      _ ->
        IO.puts("Pass a file containing the inputs as an argument.")
        System.halt(1)
    end
  end

  defp restore_state(program, noun \\ 12, verb \\ 2) do
    program
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  defp run_program(program, position \\ 0) do
    case Enum.at(program, position) do
      1 ->
        program
        |> run_operation(Enum.slice(program, position + 1, 3), &(&1 + &2))
        |> run_program(position + 4)

      2 ->
        program
        |> run_operation(Enum.slice(program, position + 1, 3), &(&1 * &2))
        |> run_program(position + 4)

      99 ->
        program
    end
  end

  defp run_operation(program, [arg1_index, arg2_index, result_index], operation) do
    List.replace_at(
      program,
      result_index,
      operation.(Enum.at(program, arg1_index), Enum.at(program, arg2_index))
    )
  end
end

IO.puts("Part 1:")
Day2.part1()

IO.puts("\nPart 2:")
Day2.part2()

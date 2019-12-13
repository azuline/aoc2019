defmodule Day2 do
  @moduledoc """
  Advent of Code 2019
  Day 2: 1202 Program Alarm
  """

  @part2_target 19_690_720

  def part1() do
    get_program()
    |> restore_state()
    |> run_program()
    |> List.first()
  end

  def part2() do
    program = get_program()

    for(noun <- 0..100, verb <- 0..100, do: {noun, verb})
    |> Enum.find(nil, &valid_noun_verb?(program, &1))
    |> (fn {noun, verb} -> 100 * noun + verb end).()
  end

  defp valid_noun_verb?(program, {noun, verb}) do
    program
    |> restore_state(noun, verb)
    |> run_program()
    |> List.first()
    |> (&(&1 == @part2_target)).()
  end

  defp get_program() do
    Path.join(__DIR__, "inputs/day2.txt")
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
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
    arg1 = Enum.at(program, arg1_index)
    arg2 = Enum.at(program, arg2_index)

    List.replace_at(program, result_index, operation.(arg1, arg2))
  end
end

part1 = Day2.part1()
IO.puts("Part 1: #{part1}")

part2 = Day2.part2()
IO.puts("Part 2: #{part2}")

defmodule Day7 do
  @moduledoc """
  Advent of Code 2019
  Day 7: Amplification Circuit
  """

  alias Day5.Opcode

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
      run_program(program, [a, 0], 0, 0)
      |> (&run_program(program, [b, &1], 0, 0)).()
      |> (&run_program(program, [c, &1], 0, 0)).()
      |> (&run_program(program, [d, &1], 0, 0)).()
      |> (&run_program(program, [e, &1], 0, 0)).()
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

  def run_program(program, inputs, position \\ 0, diagnostic_code \\ 0) do
    Opcode.at_position(program, position)
    |> run_opcode(program, diagnostic_code, inputs)
  end

  defp run_opcode(%{code: 99}, _program, diagnostic_code, _inputs) do
    diagnostic_code
  end

  defp run_opcode(%{code: 4} = opcode, program, _diagnostic_code, inputs) do
    diagnostic_code =
      Enum.at(
        program,
        Enum.at(opcode.params, 0)
      )

    run_program(program, inputs, opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 1, params: [param1, param2, param3]} = opcode,
         program,
         diagnostic_code,
         inputs
       ) do
    List.replace_at(program, param3, param1 + param2)
    |> run_program(inputs, opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 2, params: [param1, param2, param3]} = opcode,
         program,
         diagnostic_code,
         inputs
       ) do
    List.replace_at(program, param3, param1 * param2)
    |> run_program(inputs, opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 3, params: [param1]} = opcode,
         program,
         diagnostic_code,
         [input | inputs]
       ) do
    List.replace_at(program, param1, input)
    |> run_program(inputs, opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 5, params: [param1, param2]} = opcode,
         program,
         diagnostic_code,
         inputs
       ) do
    next_position = if param1 != 0, do: param2, else: opcode.next_position
    run_program(program, inputs, next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 6, params: [param1, param2]} = opcode,
         program,
         diagnostic_code,
         inputs
       ) do
    next_position = if param1 == 0, do: param2, else: opcode.next_position
    run_program(program, inputs, next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 7, params: [param1, param2, param3]} = opcode,
         program,
         diagnostic_code,
         inputs
       ) do
    List.replace_at(program, param3, if(param1 < param2, do: 1, else: 0))
    |> run_program(inputs, opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 8, params: [param1, param2, param3]} = opcode,
         program,
         diagnostic_code,
         inputs
       ) do
    List.replace_at(program, param3, if(param1 == param2, do: 1, else: 0))
    |> run_program(inputs, opcode.next_position, diagnostic_code)
  end
end

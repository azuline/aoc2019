defmodule Day5 do
  @moduledoc """
  Advent of Code 2019
  Day 2: Sunny with a Chance of Asteroids
  """

  def get_program() do
    Path.join(__DIR__, "inputs/day5.txt")
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

  def part1(program), do: run_program(program)
  def part2(program), do: run_program(program, 0, 0, 5)

  def run_program(program, position \\ 0, diagnostic_code \\ 0, input \\ 1) do
    Opcode.at_position(program, position)
    |> run_opcode(program, diagnostic_code, input)
  end

  defp run_opcode(%{code: 99}, _program, diagnostic_code, _input) do
    diagnostic_code
  end

  defp run_opcode(%{code: 4} = opcode, program, _diagnostic_code, _input) do
    diagnostic_code =
      Enum.at(
        program,
        Enum.at(opcode.params, 0)
      )

    run_program(program, opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 1, params: [param1, param2, param3]} = opcode,
         program,
         diagnostic_code,
         _input
       ) do
    List.replace_at(program, param3, param1 + param2)
    |> run_program(opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 2, params: [param1, param2, param3]} = opcode,
         program,
         diagnostic_code,
         _input
       ) do
    List.replace_at(program, param3, param1 * param2)
    |> run_program(opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 3, params: [param1]} = opcode,
         program,
         diagnostic_code,
         input
       ) do
    List.replace_at(program, param1, input)
    |> run_program(opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 5, params: [param1, param2]} = opcode,
         program,
         diagnostic_code,
         _input
       ) do
    next_position = if param1 != 0, do: param2, else: opcode.next_position
    run_program(program, next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 6, params: [param1, param2]} = opcode,
         program,
         diagnostic_code,
         _input
       ) do
    next_position = if param1 == 0, do: param2, else: opcode.next_position
    run_program(program, next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 7, params: [param1, param2, param3]} = opcode,
         program,
         diagnostic_code,
         _input
       ) do
    List.replace_at(program, param3, if(param1 < param2, do: 1, else: 0))
    |> run_program(opcode.next_position, diagnostic_code)
  end

  defp run_opcode(
         %{code: 8, params: [param1, param2, param3]} = opcode,
         program,
         diagnostic_code,
         _input
       ) do
    List.replace_at(program, param3, if(param1 == param2, do: 1, else: 0))
    |> run_program(opcode.next_position, diagnostic_code)
  end
end

defmodule Opcode do
  @moduledoc """
  I assume opcodes will never be negative.
  """

  defstruct [:code, :params, :next_position]

  @num_params %{
    1 => 3,
    2 => 3,
    3 => 1,
    4 => 1,
    5 => 2,
    6 => 2,
    7 => 3,
    8 => 3
  }

  # These are indices of parameters that are for writing--that is, they should
  # be returned as is in the opcode, and not treated as an index to a parameter
  # value when constructing the opcode.

  @write_indices %{
    1 => [2],
    2 => [2],
    3 => [0],
    4 => [0],
    5 => [],
    6 => [],
    7 => [2],
    8 => [2]
  }

  def at_position(program, position) do
    Enum.at(program, position)
    |> split_code_and_modes()
    |> construct(program, position)
  end

  defp split_code_and_modes(opcode) do
    {rem(opcode, 100), div(opcode, 100)}
  end

  # Handle the exit code case explicitly.
  defp construct({99, _modes}, _program, _position) do
    %__MODULE__{code: 99}
  end

  defp construct({code, modes}, program, position) do
    params =
      try do
        for i <- 1..@num_params[code] do
          value = Enum.at(program, position + i)

          if parse_mode(modes, i - 1) == 0 and (i - 1) not in @write_indices[code],
            do: Enum.at(program, value),
            else: value
        end
      rescue
        ArgumentError ->
          IO.puts("Invalid opcode received: #{code}")
          System.halt(1)
      end

    %__MODULE__{
      code: code,
      params: params,
      next_position: position + @num_params[code] + 1
    }
  end

  defp parse_mode(modes, index) do
    modes
    |> div(round(:math.pow(10, index)))
    |> rem(10)
  end
end

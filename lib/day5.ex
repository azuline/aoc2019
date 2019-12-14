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
  end

  def part1(program), do: run_program(program)

  def run_program(program, position \\ 0, diagnostic_code \\ 0) do
    Opcode.at_position(program, position)
    |> run_opcode(program, diagnostic_code)
  end

  defp run_opcode(%{code: 99}, _program, diagnostic_code) do
    diagnostic_code
  end

  defp run_opcode(%{code: 4} = opcode, program, _diagnostic_code) do
    program
    |> execute_operation(opcode, opcode.params)
    |> (&run_program(program, opcode.next_position, &1)).()
  end

  defp run_opcode(opcode, program, diagnostic_code) do
    program
    |> execute_operation(opcode, opcode.params)
    |> run_program(opcode.next_position, diagnostic_code)
  end

  defp execute_operation(program, %{code: 1}, [param1, param2, param3]) do
    List.replace_at(program, param3, param1 + param2)
  end

  defp execute_operation(program, %{code: 2}, [param1, param2, param3]) do
    List.replace_at(program, param3, param1 * param2)
  end

  defp execute_operation(program, %{code: 3}, [param]) do
    List.replace_at(program, param, _input = 1)
  end

  defp execute_operation(program, %{code: 4}, [param]) do
    Enum.at(program, param)
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
    4 => 1
  }

  # These are indices of parameters that are for writing--that is, they should
  # be returned as is in the opcode, and not treated as an index to a parameter
  # value when constructing the opcode.

  @write_indices %{
    1 => [3],
    2 => [3],
    3 => [1],
    4 => [1]
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
      for i <- 1..@num_params[code] do
        value = Enum.at(program, position + i)

        if parse_mode(modes, i - 1) == 0 and i not in @write_indices[code],
          do: Enum.at(program, value),
          else: value
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

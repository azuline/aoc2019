defmodule Day5 do
  @moduledoc """
  Advent of Code 2019
  Day 2: Sunny with a Chance of Asteroids
  """

  def execute() do
    IO.puts("Running Part 1:")
    Day5.part1()

    # part2 = Day5.part2()
    # IO.puts("Part 2: #{part2}")
  end

  def part1() do
    get_program()
    |> run_program()
  end

  defp get_program() do
    Path.join(__DIR__, "inputs/day5.txt")
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp run_program(program, position \\ 0) do
    Opcode.at_position(program, position)
    |> execute_opcode(program, position)
  end

  defp execute_opcode(%{code: 99} = _opcode, _program, _position) do
    IO.puts("Exit code recevied, stopping.")
  end

  defp execute_opcode(opcode, program, _position) do
    program
    |> execute_operation(opcode, opcode.params)
    |> run_program(opcode.next_position)
  end

  defp execute_operation(program, %{code: 1}, [param1, param2, param3]) do
    arg1 = Parameter.get_value(param1, program)
    arg2 = Parameter.get_value(param2, program)

    # We want the value, not the number at the index.
    index = param3.value

    List.replace_at(program, index, arg1 + arg2)
  end

  defp execute_operation(program, %{code: 2}, [param1, param2, param3]) do
    arg1 = Parameter.get_value(param1, program)
    arg2 = Parameter.get_value(param2, program)

    # We want the value, not the number at the index.
    index = param3.value

    List.replace_at(program, index, arg1 * arg2)
  end

  defp execute_operation(program, %{code: 3}, [param]) do
    List.replace_at(program, param.value, _input = 1)
  end

  defp execute_operation(program, %{code: 4}, [param]) do
    output = Enum.at(program, param.value)

    if output == 0,
      do: IO.puts("Successfully passed a diagnostic test."),
      else: IO.puts("Recieved non-zero diagnostic code: #{output}.")

    program
  end
end

defmodule Parameter do
  defstruct [:value, :mode]

  def get_value(param, program) do
    case param.mode do
      0 -> Enum.at(program, param.value)
      1 -> param.value
    end
  end
end

defmodule Opcode do
  @moduledoc """
  I assume opcodes will never be negative.
  """

  defstruct [:code, :params, :next_position]

  @lengths %{
    1 => 4,
    2 => 4,
    3 => 2,
    4 => 2
  }

  def at_position(program, position) do
    Enum.at(program, position)
    |> split_opcode()
    |> construct(program, position)
  end

  def get_param_values(opcode, program) do
    for param <- opcode.params, do: Parameter.get_value(param, program)
  end

  defp split_opcode(opcode) do
    {rem(opcode, 100), div(opcode, 100)}
  end

  # Handle the exit code case explicitly.
  defp construct({99, _modes}, _program, _position) do
    %__MODULE__{code: 99}
  end

  defp construct({code, modes}, program, position) do
    params =
      for i <- 1..(@lengths[code] - 1),
          do: %Parameter{
            value: Enum.at(program, position + i),
            mode: parse_mode(modes, i - 1)
          }

    %__MODULE__{
      code: code,
      params: params,
      next_position: position + @lengths[code]
    }
  end

  defp parse_mode(modes, index) do
    modes
    |> div(round(:math.pow(10, index)))
    |> rem(10)
  end
end

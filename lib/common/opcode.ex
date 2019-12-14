defmodule Opcode do
  @moduledoc """
  I assume opcodes will never be negative.
  """

  defstruct [:code, :params, :next_pos]

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
      next_pos: position + @num_params[code] + 1
    }
  end

  defp parse_mode(modes, index) do
    modes
    |> div(round(:math.pow(10, index)))
    |> rem(10)
  end
end

defmodule IntCode do
  use GenServer

  def run_computer(name, inputs \\ []) do
    case GenServer.call(name, {:run, inputs}) do
      {:output, _code} -> run_computer(name)
      {:exit, code} -> code
    end
  end

  @impl true
  def init(program) do
    {:ok, {program, 0, [], 0}}
  end

  @impl true
  def handle_call({:run, inputs}, _from, {program, position, old_inputs, diagnostic}) do
    {exit_type, program, position, inputs, diagnostic} =
      run_program(program, position, inputs ++ old_inputs, diagnostic)

    {:reply, {exit_type, diagnostic}, {program, position, inputs, diagnostic}, :hibernate}
  end

  def run_program(program, position, inputs, diagnostic) do
    Opcode.at_position(program, position)
    |> execute_opcode(program, position, inputs, diagnostic)
  end

  # Opcodes that interrupt program execution.

  def execute_opcode(
        %{code: 4, params: [loc], next_pos: next_pos},
        program,
        _position,
        inputs,
        _diagnostic
      ),
      do: {:output, program, next_pos, inputs, Enum.at(program, loc)}

  def execute_opcode(%{code: 99}, program, position, inputs, diagnostic),
    do: {:exit, program, position, inputs, diagnostic}

  # Opcode for reading input.

  def execute_opcode(
        %{code: 3, params: [loc], next_pos: next_pos},
        program,
        _position,
        [input | inputs],
        diagnostic
      ),
      do:
        program
        |> List.replace_at(loc, input)
        |> run_program(next_pos, inputs, diagnostic)

  # Opcodes that shift the program's current position.

  def execute_opcode(%{code: code} = opcode, program, _position, inputs, diagnostic)
      when code == 5 or code == 6,
      do: run_program(program, get_next_pos(opcode), inputs, diagnostic)

  # Opcodes for program manipulation.

  def execute_opcode(
        %{code: code, params: params, next_pos: next_pos},
        program,
        _position,
        inputs,
        diagnostic
      ) do
    cond do
      code == 1 -> execute_addition(program, params)
      code == 2 -> execute_multiplication(program, params)
      code == 7 -> execute_lt_substitution(program, params)
      code == 8 -> execute_eq_substitution(program, params)
    end
    |> run_program(next_pos, inputs, diagnostic)
  end

  defp get_next_pos(%{code: 5, params: [check, pos], next_pos: default_pos}),
    do: if(check != 0, do: pos, else: default_pos)

  defp get_next_pos(%{code: 6, params: [check, pos], next_pos: default_pos}),
    do: if(check == 0, do: pos, else: default_pos)

  def execute_addition(program, [addend1, addend2, index]),
    do: List.replace_at(program, index, addend1 + addend2)

  def execute_multiplication(program, [factor1, factor2, index]),
    do: List.replace_at(program, index, factor1 * factor2)

  def execute_lt_substitution(program, [arg1, arg2, loc]),
    do: List.replace_at(program, loc, if(arg1 < arg2, do: 1, else: 0))

  def execute_eq_substitution(program, [arg1, arg2, loc]),
    do: List.replace_at(program, loc, if(arg1 == arg2, do: 1, else: 0))
end

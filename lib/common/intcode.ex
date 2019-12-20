defmodule IntCode do
  use GenServer

  def run_computer(name, inputs \\ [], timeout \\ 5000) do
    case GenServer.call(name, {:run, inputs}, timeout) do
      {:output, _code} -> run_computer(name, [], timeout)
      {:exit, code} -> code
    end
  end

  @impl true
  def init(program) do
    state = %{
      program: program,
      position: 0,
      inputs: [],
      diagnostic: 0,
      relative_base: 0
    }

    {:ok, state}
  end

  @impl true
  def handle_call({:run, new_inputs}, _from, %{inputs: inputs} = state) do
    {exit_type, state} = run_program(%{state | inputs: new_inputs ++ inputs})

    {:reply, {exit_type, state.diagnostic}, state, :hibernate}
  end

  def run_program(state) do
    Opcode.at_position(state.program, state.position, state.relative_base)
    |> execute_opcode(state)
  end

  # Opcodes that interrupt program execution.

  def execute_opcode(%{code: 4, params: [diagnostic], next_pos: next_pos}, state) do
    {:output, %{state | position: next_pos, diagnostic: diagnostic}}
  end

  def execute_opcode(%{code: 99}, state) do
    {:exit, state}
  end

  # Opcode for reading input.

  def execute_opcode(
        %{code: 3, params: [loc], next_pos: next_pos},
        %{program: program, inputs: [input | inputs]} = state
      ) do
    program = List.replace_at(program, loc, input)
    run_program(%{state | program: program, position: next_pos, inputs: inputs})
  end

  # Opcodes that change auxiliary program state.

  def execute_opcode(
        %{code: 9, next_pos: next_pos, params: [shift]},
        %{relative_base: relative_base} = state
      ) do
    run_program(%{state | position: next_pos, relative_base: relative_base + shift})
  end

  # Opcodes that shift the program's current position.

  def execute_opcode(%{code: code} = opcode, %{program: program} = state)
      when code == 5 or code == 6 do
    run_program(%{state | program: program, position: get_next_pos(opcode)})
  end

  # Opcodes for program manipulation.

  def execute_opcode(
        %{code: code, params: params, next_pos: next_pos},
        %{program: program} = state
      ) do
    program =
      cond do
        code == 1 -> execute_addition(program, params)
        code == 2 -> execute_multiplication(program, params)
        code == 7 -> execute_lt_substitution(program, params)
        code == 8 -> execute_eq_substitution(program, params)
      end

    run_program(%{state | program: program, position: next_pos})
  end

  def extend_program(program, index) do
    if index >= length(program),
      do: program ++ for(_ <- 0..index, do: nil),
      else: program
  end

  defp get_next_pos(%{code: 5, params: [check, pos], next_pos: default_pos}),
    do: if(check != 0, do: pos, else: default_pos)

  defp get_next_pos(%{code: 6, params: [check, pos], next_pos: default_pos}),
    do: if(check == 0, do: pos, else: default_pos)

  defp execute_addition(program, [addend1, addend2, index]),
    do:
      program
      |> extend_program(index)
      |> List.replace_at(index, addend1 + addend2)

  defp execute_multiplication(program, [factor1, factor2, index]),
    do:
      program
      |> extend_program(index)
      |> List.replace_at(index, factor1 * factor2)

  defp execute_lt_substitution(program, [arg1, arg2, loc]),
    do:
      program
      |> extend_program(loc)
      |> List.replace_at(loc, if(arg1 < arg2, do: 1, else: 0))

  defp execute_eq_substitution(program, [arg1, arg2, loc]),
    do:
      program
      |> extend_program(loc)
      |> List.replace_at(loc, if(arg1 == arg2, do: 1, else: 0))
end

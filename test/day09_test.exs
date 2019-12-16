defmodule Day09Test do
  use ExUnit.Case, async: true

  import Day09
  import IntCode, only: [run_computer: 1]

  def get_all_diagnostic_codes(name, codes \\ [], inputs \\ []) do
    case GenServer.call(name, {:run, inputs}) do
      {:output, code} -> get_all_diagnostic_codes(name, codes ++ [code])
      {:exit, _code} -> codes
    end
  end

  test "part 1" do
    assert 3_533_056_970 == get_program() |> part1()
  end

  # The real calculation for part 2 takes several seconds.

  # test "part 2" do
  #   assert 72852 == get_program() |> part2()
  # end

  test "part 1 boost 1" do
    program = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
    GenServer.start_link(IntCode, program, name: Test)

    assert get_all_diagnostic_codes(Test) == program
  end

  test "part 1 boost 2" do
    program = [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0]
    GenServer.start_link(IntCode, program, name: Test)

    output_length =
      run_computer(Test)
      |> Integer.to_string()
      |> String.length()

    assert output_length == 16
  end

  test "part 1 boost 3" do
    program = [104, 1_125_899_906_842_624, 99]
    GenServer.start_link(IntCode, program, name: Test)
    assert run_computer(Test) == 1_125_899_906_842_624
  end
end

defmodule Day05Test do
  use ExUnit.Case, async: true

  import Day05
  import IntCode, only: [run_computer: 2]
  alias Day05.{Part1, Part2}

  test "part 1" do
    assert 11_193_703 == get_program() |> Part1.run()
  end

  test "part 2" do
    assert 12_410_607 == get_program() |> Part2.run()
  end

  @example_program [
    3,
    21,
    1008,
    21,
    8,
    20,
    1005,
    20,
    22,
    107,
    8,
    21,
    20,
    1006,
    20,
    31,
    1106,
    0,
    36,
    98,
    0,
    0,
    1002,
    21,
    125,
    20,
    4,
    20,
    1105,
    1,
    46,
    104,
    999,
    1105,
    1,
    46,
    1101,
    1000,
    1,
    20,
    4,
    20,
    1105,
    1,
    46,
    98,
    99
  ]

  test "part 2 input 8" do
    GenServer.start_link(IntCode, @example_program, name: Test)
    assert run_computer(Test, [8]) == 1000
  end

  test "part 2 input 9" do
    GenServer.start_link(IntCode, @example_program, name: Test)
    assert run_computer(Test, [9]) == 1001
  end
end

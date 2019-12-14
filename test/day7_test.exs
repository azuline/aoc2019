defmodule Day7Test do
  use ExUnit.Case, async: true

  import Day7

  test "get permutations" do
    permutations =
      get_permutations([1, 2, 3])
      |> Enum.sort()

    expected = [
      [1, 2, 3],
      [1, 3, 2],
      [2, 1, 3],
      [2, 3, 1],
      [3, 1, 2],
      [3, 2, 1]
    ]

    assert permutations == expected
  end

  test "part 1 max thruster 1" do
    program = [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0]

    assert part1(program) == "Max thruster signal 43210 from sequence 43210"
  end

  test "part 1 max thruster 2" do
    program = [
      3,
      23,
      3,
      24,
      1002,
      24,
      10,
      24,
      1002,
      23,
      -1,
      23,
      101,
      5,
      23,
      23,
      1,
      24,
      23,
      23,
      4,
      23,
      99,
      0,
      0
    ]

    assert part1(program) == "Max thruster signal 54321 from sequence 01234"
  end
end

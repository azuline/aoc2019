defmodule Day07Test do
  use ExUnit.Case, async: true

  import Day07
  alias Day07.{Part1, Part2, Combinatorics}

  test "part 1" do
    assert "Max thruster signal 273814 from sequence 20431" == get_program() |> Part1.run()
  end

  test "part 2" do
    assert "Max thruster signal 34579864 from sequence 65978" == get_program() |> Part2.run()
  end

  test "get permutations" do
    permutations =
      Combinatorics.get_permutations([1, 2, 3])
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

    assert Part1.run(program) == "Max thruster signal 43210 from sequence 43210"
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

    assert Part1.run(program) == "Max thruster signal 54321 from sequence 01234"
  end

  test "part 2 feedback loop 1" do
    program = [
      3,
      26,
      1001,
      26,
      -4,
      26,
      3,
      27,
      1002,
      27,
      2,
      27,
      1,
      27,
      26,
      27,
      4,
      27,
      1001,
      28,
      -1,
      28,
      1005,
      28,
      6,
      99,
      0,
      0,
      5
    ]

    assert Part2.run(program) == "Max thruster signal 139629729 from sequence 98765"
  end

  test "part 2 feedback loop 2" do
    program = [
      3,
      52,
      1001,
      52,
      -5,
      52,
      3,
      53,
      1,
      52,
      56,
      54,
      1007,
      54,
      5,
      55,
      1005,
      55,
      26,
      1001,
      54,
      -5,
      54,
      1105,
      1,
      12,
      1,
      53,
      54,
      53,
      1008,
      54,
      0,
      55,
      1001,
      55,
      1,
      55,
      2,
      53,
      55,
      53,
      4,
      53,
      1001,
      56,
      -1,
      56,
      1005,
      56,
      6,
      99,
      0,
      0,
      0,
      0,
      10
    ]

    assert Part2.run(program) == "Max thruster signal 18216 from sequence 97856"
  end
end

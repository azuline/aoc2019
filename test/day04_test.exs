defmodule Day04Test do
  use ExUnit.Case, async: true

  import Day04
  alias Day04.{Part1, Part2}

  test "part 1" do
    [lower, upper] = get_range()

    assert 1665 == Part1.run(lower, upper)
  end

  test "part 2" do
    [lower, upper] = get_range()

    assert 1131 == Part2.run(lower, upper)
  end

  test "valid password part 1 test 1" do
    assert Part1.valid_password?(111_111, &Part1.adjacent?/2)
  end

  test "valid password part 1 test 2" do
    assert not Part1.valid_password?(223_450, &Part1.adjacent?/2)
  end

  test "valid password part 1 test 3" do
    assert not Part1.valid_password?(123_789, &Part1.adjacent?/2)
  end

  test "valid password part 2 test 1" do
    assert Part1.valid_password?(112_233, &Part2.exactly_2_adjacent?/2)
  end

  test "valid password part 2 test 2" do
    assert not Part1.valid_password?(123_444, &Part2.exactly_2_adjacent?/2)
  end

  test "valid password part 2 test 3" do
    assert Part1.valid_password?(111_122, &Part2.exactly_2_adjacent?/2)
  end

  test "exactly 2 adjacent" do
    for i <- 0..5 do
      assert not Part2.exactly_2_adjacent?([1, 2, 3, 4, 4, 4], i)
    end
  end
end

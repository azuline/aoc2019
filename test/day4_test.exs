defmodule Day4Test do
  use ExUnit.Case, async: true

  import Day4

  test "part 1" do
    [lower, upper] = get_range()

    assert 1665 == part1(lower, upper)
  end

  test "part 2" do
    [lower, upper] = get_range()

    assert 1131 == part2(lower, upper)
  end

  test "valid password part 1 test 1" do
    assert valid_password?(111_111, &adjacent?/2)
  end

  test "valid password part 1 test 2" do
    assert not valid_password?(223_450, &adjacent?/2)
  end

  test "valid password part 1 test 3" do
    assert not valid_password?(123_789, &adjacent?/2)
  end

  test "valid password part 2 test 1" do
    assert valid_password?(112_233, &exactly_2_adjacent?/2)
  end

  test "valid password part 2 test 2" do
    assert not valid_password?(123_444, &exactly_2_adjacent?/2)
  end

  test "valid password part 2 test 3" do
    assert valid_password?(111_122, &exactly_2_adjacent?/2)
  end

  test "exactly 2 adjacent" do
    for i <- 0..5 do
      assert not exactly_2_adjacent?([1, 2, 3, 4, 4, 4], i)
    end
  end
end

defmodule Day3Test do
  use ExUnit.Case, async: true

  import Day3

  @test_spec [
    ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
    ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
  ]

  test "part 1" do
    assert 1211 == get_specs() |> part1()
  end

  test "part 2" do
    assert 101_386 == get_specs() |> part2()
  end

  test "part 1 test spec" do
    assert part1(@test_spec) == 159
  end

  test "part 2 test spec" do
    assert part2(@test_spec) == 610
  end
end

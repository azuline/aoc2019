defmodule Day11Test do
  use ExUnit.Case, async: true

  import Day12
  alias Day12.Moon

  test "part 1" do
    assert 14809 == get_moons() |> part1()
  end

  test "part 2" do
    assert 282_270_365_571_288 == get_moons() |> part2()
  end

  @test_moons [
    %Moon{position: %{x: -1, y: 0, z: 2}},
    %Moon{position: %{x: 2, y: -10, z: -7}},
    %Moon{position: %{x: 4, y: -8, z: 8}},
    %Moon{position: %{x: 3, y: 5, z: -1}}
  ]

  test "part 1 example 1" do
    assert 179 == simulate_steps(@test_moons, 10) |> calculate_energy()
  end

  test "part 2 example 1" do
    assert 2772 == part2(@test_moons)
  end
end

defmodule Day6Test do
  use ExUnit.Case, async: true

  import Day6

  test "part 1" do
    assert 162_816 == get_orbits() |> part1()
  end

  test "part 2" do
    assert 304 == get_orbits() |> part2()
  end

  @test_orbits [
    ["COM", "B"],
    ["B", "C"],
    ["C", "D"],
    ["D", "E"],
    ["E", "F"],
    ["B", "G"],
    ["G", "H"],
    ["D", "I"],
    ["E", "J"],
    ["J", "K"],
    ["K", "L"]
  ]

  test "map parents to children" do
    map = %{
      "COM" => ["B"],
      "C" => ["D"],
      "D" => ["I", "E"],
      "B" => ["G", "C"],
      "G" => ["H"],
      "E" => ["J", "F"],
      "J" => ["K"],
      "K" => ["L"]
    }

    assert map_parents_to_children(@test_orbits) == map
  end

  test "part 1 test orbits" do
    assert part1(@test_orbits) == 42
  end

  test "part 2 test orbits" do
    orbits = [["K", "YOU"], ["I", "SAN"] | @test_orbits]

    assert part2(orbits) == 4
  end
end

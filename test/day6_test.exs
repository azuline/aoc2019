defmodule Day6Test do
  use ExUnit.Case, async: true

  import Day6

  @orbits [
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

    assert map_parents_to_children(@orbits) == map
  end

  test "part 1" do
    assert part1(@orbits) == 42
  end

  test "part 2" do
    orbits = [["K", "YOU"], ["I", "SAN"] | @orbits]

    assert part2(orbits) == 4
  end
end

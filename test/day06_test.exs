defmodule Day06Test do
  use ExUnit.Case, async: true

  import Day06
  alias Day06.{Part1, Part2}

  test "part 1" do
    assert 162_816 == get_orbits() |> Part1.run()
  end

  test "part 2" do
    assert 304 == get_orbits() |> Part2.run()
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

    assert Part1.map_parents_to_children(@test_orbits) == map
  end

  test "part 1 test orbits" do
    assert Part1.run(@test_orbits) == 42
  end

  test "part 2 test orbits" do
    orbits = [["K", "YOU"], ["I", "SAN"] | @test_orbits]

    assert Part2.run(orbits) == 4
  end
end

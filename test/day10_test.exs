defmodule Day10Test do
  use ExUnit.Case, async: true

  import Day10

  test "part 1" do
    assert 319 == get_map() |> part1()
  end

  def parse_map(map) do
    map
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&Enum.map(&1, fn e -> e == "#" end))
    |> Enum.to_list()
  end

  test "part 1 example 1" do
    map =
      parse_map([
        ".#..#",
        ".....",
        "#####",
        "....#",
        "...##"
      ])

    assert 8 == part1(map)
  end

  test "part 1 example 2" do
    map =
      parse_map([
        "......#.#.",
        "#..#.#....",
        "..#######.",
        ".#.#.###..",
        ".#..#.....",
        "..#....#.#",
        "#..#....#.",
        ".##.#..###",
        "##...#..#.",
        ".#....####"
      ])

    assert 33 == part1(map)
  end
end

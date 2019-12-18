defmodule Day10Test do
  use ExUnit.Case, async: true

  import Day10

  test "part 1" do
    assert 319 == get_map() |> part1()
  end

  test "part 2" do
    assert 517 == get_map() |> part2()
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

  defp rel(x, y), do: {5 + x, 5 + y}

  test "sort asteroid to list" do
    ms_coord = {2, 2}

    asteroids =
      parse_map([
        ".#..#",
        ".....",
        "#####",
        "....#",
        "...##"
      ])
      |> construct_asteroids_map()

    asteroids_list = sort_asteroids_into_list(asteroids, ms_coord)

    assert asteroids_list == [
             [{4, 0}],
             [{3, 2}, {4, 2}],
             [{4, 3}],
             [{4, 4}],
             [{3, 4}],
             [{1, 2}, {0, 2}],
             [{1, 0}]
           ]
  end

  test "get 200th asteroid" do
    asteroids = [[0, :asteroid]] ++ for i <- 1..198, do: [i]

    assert :asteroid == get_200th_asteroid_coords(asteroids)
  end

  # Remark: 0,0 coord is in the top left.

  test "calculate slope weight top right sector" do
    ms_coord = {2, 2}

    weight1 = calculate_slope_weight(rel(3, -1), ms_coord)
    weight2 = calculate_slope_weight(rel(-1, 3), ms_coord)

    assert weight1 == {1, 1 / 3}
    assert weight2 == {1, 3}
  end

  test "calculate slope weight bottom right sector" do
    ms_coord = {5, 5}

    weight1 = calculate_slope_weight(rel(3, 1), ms_coord)
    weight2 = calculate_slope_weight(rel(1, 3), ms_coord)

    assert weight1 == {1, 1 / 3}
    assert weight2 == {1, 3}
  end

  test "calculate slope weight bottom left sector" do
    ms_coord = {5, 5}

    weight1 = calculate_slope_weight(rel(-1, 3), ms_coord)
    weight2 = calculate_slope_weight(rel(-3, 1), ms_coord)

    assert weight1 == {2, 1 / 3}
    assert weight2 == {2, 3}
  end

  test "calculate slope weight top left sector" do
    ms_coord = {5, 5}

    weight1 = calculate_slope_weight(rel(-3, -1), ms_coord)
    weight2 = calculate_slope_weight(rel(-1, -3), ms_coord)

    assert weight1 == {3, 1 / 3}
    assert weight2 == {3, 3}
  end
end

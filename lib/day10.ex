defmodule Day10 do
  @moduledoc """
  Advent of Code 2019
  Day 10: Monitoring Station
  """

  def get_map() do
    Path.join(__DIR__, "inputs/day10.txt")
    |> File.open!()
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.map(&Enum.map(&1, fn e -> e == "#" end))
  end

  def execute() do
    map = get_map()

    IO.puts("Part 1: #{part1(map)}")
  end

  def part1(map) do
    asteroids = construct_asteroids_map(map)
    dimensions = get_asteroids_dimensions(map)

    asteroids
    |> Stream.map(fn {coords, is_asteroid} ->
      num_visible =
        if is_asteroid,
          do: count_visible_asteroids(coords, asteroids, dimensions),
          else: 0

      {coords, num_visible}
    end)
    |> Enum.max_by(&elem(&1, 1))
    |> (&elem(&1, 1)).()
  end

  def construct_asteroids_map(map) do
    for {row, x} <- Enum.with_index(map),
        {is_asteroid, y} <- Enum.with_index(row),
        into: %{},
        do: {{x, y}, is_asteroid}
  end

  def get_asteroids_dimensions(map) do
    {length(Enum.at(map, 0)), length(map)}
  end

  def count_visible_asteroids(coords, asteroids, {width, height}) do
    for row <- 0..(width - 1), col <- 0..(height - 1) do
      if asteroids[{row, col}] and
           coords != {row, col} and
           not exists_blocking_asteroid?(coords, {row, col}, asteroids),
         do: 1,
         else: 0
    end
    |> Enum.sum()
  end

  # Recursive function to check for asteroids that block line of sight.

  defp exists_blocking_asteroid?({x, y} = coords, asteroid, asteroids) do
    {mx, my} = slope = calculate_slope(coords, asteroid)

    exists_blocking_asteroid?({x + mx, y + my}, asteroid, slope, asteroids)
  end

  defp exists_blocking_asteroid?({x, y} = coords, asteroid, {mx, my} = slope, asteroids) do
    cond do
      coords == asteroid -> false
      asteroids[coords] -> true
      true -> exists_blocking_asteroid?({x + mx, y + my}, asteroid, slope, asteroids)
    end
  end

  defp calculate_slope({x1, y1}, {x2, y2}) do
    mx = x2 - x1
    my = y2 - y1

    case Integer.gcd(mx, my) do
      1 -> {mx, my}
      gcd -> {trunc(mx / gcd), trunc(my / gcd)}
    end
  end
end

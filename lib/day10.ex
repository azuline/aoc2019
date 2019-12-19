defmodule Day10 do
  @moduledoc """
  Advent of Code 2019
  Day 10: Monitoring Station
  """

  alias Day10.{Part1, Part2}

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

    IO.puts("Part 1: #{Part1.run(map)}")
    IO.puts("Part 2: #{Part2.run(map)}")
  end
end

defmodule Day10.Part1 do
  def run(map) do
    asteroids = construct_asteroids_map(map)
    dimensions = get_asteroids_dimensions(map)

    get_monitoring_station_coords(asteroids, dimensions)
    |> (&elem(&1, 1)).()
  end

  def construct_asteroids_map(map) do
    for {row, y} <- Enum.with_index(map),
        {is_asteroid, x} <- Enum.with_index(row),
        into: %{},
        do: {{x, y}, is_asteroid}
  end

  def get_asteroids_dimensions(map) do
    {length(Enum.at(map, 0)), length(map)}
  end

  def get_monitoring_station_coords(asteroids, dimensions) do
    asteroids
    |> Stream.map(fn {coords, is_asteroid} ->
      num_visible =
        if is_asteroid,
          do: count_visible_asteroids(coords, asteroids, dimensions),
          else: 0

      {coords, num_visible}
    end)
    |> Enum.max_by(&elem(&1, 1))
  end

  defp count_visible_asteroids(coords, asteroids, {width, height}) do
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

defmodule Day10.Part2 do
  alias Day10.Part1

  def run(map) do
    asteroids = Part1.construct_asteroids_map(map)
    dimensions = Part1.get_asteroids_dimensions(map)

    ms_coords =
      Part1.get_monitoring_station_coords(asteroids, dimensions)
      |> (&elem(&1, 0)).()

    sort_asteroids_into_list(asteroids, ms_coords)
    |> get_200th_asteroid_coords()
    |> (fn {x, y} -> 100 * x + y end).()
  end

  def sort_asteroids_into_list(asteroids, {ms_x, ms_y} = ms_coords) do
    asteroids
    |> Map.to_list()
    |> Stream.reject(&(elem(&1, 0) == ms_coords))
    |> Stream.reject(&(elem(&1, 1) == false))
    |> Enum.map(fn {coords, _} -> {calculate_slope_weight(coords, ms_coords), coords} end)
    |> transform_slope_weights_into_map()
    |> Map.to_list()
    |> Enum.sort(fn {{weight1, abs_slope1}, _}, {{weight2, abs_slope2}, _} ->
      if weight1 == weight2, do: abs_slope1 < abs_slope2, else: weight1 < weight2
    end)
    |> Enum.map(fn {_, coords} ->
      Enum.sort_by(coords, fn {x, y} -> :math.pow(x - ms_x, 2) + :math.pow(y - ms_y, 2) end)
    end)
  end

  def get_200th_asteroid_coords([[asteroid | asteroids_list] | coords_list], ctr \\ 1) do
    cond do
      ctr == 200 ->
        asteroid

      asteroids_list == [] ->
        get_200th_asteroid_coords(coords_list, ctr + 1)

      true ->
        get_200th_asteroid_coords(coords_list ++ [asteroids_list], ctr + 1)
    end
  end

  def calculate_slope_weight({x, y}, {ms_x, ms_y}) do
    diff = %{x: x - ms_x, y: y - ms_y}

    cond do
      diff.x >= 0 and diff.y < 0 -> {0, abs(diff.x / diff.y)}
      diff.x > 0 and diff.y >= 0 -> {1, diff.y / diff.x}
      diff.x <= 0 and diff.y > 0 -> {2, abs(diff.x / diff.y)}
      diff.x < 0 and diff.y <= 0 -> {3, diff.y / diff.x}
    end
  end

  defp transform_slope_weights_into_map(weights, map \\ %{})

  defp transform_slope_weights_into_map([], map), do: map

  defp transform_slope_weights_into_map([{weight, coords} | weights], map) do
    map = Map.update(map, weight, [coords], &[coords | &1])

    transform_slope_weights_into_map(weights, map)
  end
end

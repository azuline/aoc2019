defmodule Day3 do
  @moduledoc """
  Advent of Code 2019
  Day 3: Crossed Wires

  $ elixir day3.exs input/day3.txt
  """

  def part1() do
    get_specs()
    |> generate_points()
    |> find_collisions()
    # Since we only care about {x, y}, and not {x, y, ctr}, we can discard
    # the second point in the {point1, point2} tuple because they have the
    # same {x, y}.
    |> Enum.map(&elem(&1, 0))
    |> Enum.min_by(&(abs(&1.x) + abs(&1.y)))
    |> (&(abs(&1.x) + abs(&1.y))).()
  end

  def part2() do
    get_specs()
    |> generate_points()
    |> find_collisions()
    |> Enum.min_by(&(elem(&1, 0).ctr + elem(&1, 1).ctr))
    |> (&(elem(&1, 0).ctr + elem(&1, 1).ctr)).()
  end

  defp get_specs() do
    case System.argv() do
      [filepath] ->
        File.open!(filepath)
        |> IO.stream(:line)
        |> Stream.map(&String.trim/1)
        |> Enum.map(&String.split(&1, ","))

      _ ->
        IO.puts("Pass a file containing the inputs as an argument.")
        System.halt(1)
    end
  end

  defp generate_points(specs) do
    {
      generate_points_from_spec(Enum.at(specs, 0)),
      generate_points_from_spec(Enum.at(specs, 1))
    }
  end

  defp generate_points_from_spec(spec, points \\ [], cur \\ %{x: 0, y: 0, ctr: 0})

  defp generate_points_from_spec(spec, points, _cur)
       when spec == [] or spec == nil,
       do: points

  defp generate_points_from_spec([instruction | tail], points, cur) do
    case String.split_at(instruction, 1) do
      {_, "0"} ->
        generate_points_from_spec(tail, points, cur)

      {direction, dist} ->
        new_cur = move_cur(cur, direction)
        new_spec = ["#{direction}#{String.to_integer(dist) - 1}" | tail]
        new_points = [new_cur | points]

        generate_points_from_spec(new_spec, new_points, new_cur)
    end
  end

  defp move_cur(cur, direction) do
    cur = %{cur | ctr: cur.ctr + 1}

    case direction do
      "U" -> %{cur | y: cur.y + 1}
      "R" -> %{cur | x: cur.x + 1}
      "D" -> %{cur | y: cur.y - 1}
      "L" -> %{cur | x: cur.x - 1}
    end
  end

  defp find_collisions({points1, points2}) do
    points1_map = for point <- points1, into: %{}, do: {Map.delete(point, :ctr), point}

    find_collisions_in_map(points2, points1_map)
  end

  defp find_collisions_in_map(points, map, collisions \\ [])

  defp find_collisions_in_map([], _map, collisions), do: collisions

  defp find_collisions_in_map([point | points], map, collisions) do
    key = %{x: point.x, y: point.y}

    collisions =
      if Map.has_key?(map, key),
        do: [{point, Map.get(map, key)} | collisions],
        else: collisions

    find_collisions_in_map(points, map, collisions)
  end
end

part1 = Day3.part1()
IO.puts("Part 1: #{part1}")

part2 = Day3.part2()
IO.puts("Part 2: #{part2}")

defmodule Point do
  defstruct x: 0, y: 0, ctr: 0

  def get_dimensions(point), do: {point.x, point.y}
end

defmodule Day3 do
  @moduledoc """
  Advent of Code 2019
  Day 3: Crossed Wires

  $ elixir day3.exs input/day3.txt
  """

  defp get_specs() do
    Path.join(__DIR__, "inputs/day3.txt")
    |> File.open!()
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ","))
  end

  def execute() do
    specs = get_specs()

    part1 = Day3.part1(specs)
    IO.puts("Part 1: #{part1}")

    part2 = Day3.part2(specs)
    IO.puts("Part 2: #{part2}")
  end

  def part1(specs) do
    # Since we only care about {x, y}, and not {x, y, ctr}, we can discard
    # the second point in the {point1, point2} tuple because they have the
    # same {x, y}.

    specs
    |> generate_points()
    |> find_collisions()
    |> Enum.map(&elem(&1, 0))
    |> Enum.min_by(&(abs(&1.x) + abs(&1.y)))
    |> (&(abs(&1.x) + abs(&1.y))).()
  end

  def part2(specs) do
    specs
    |> generate_points()
    |> find_collisions()
    |> Enum.min_by(&(elem(&1, 0).ctr + elem(&1, 1).ctr))
    |> (&(elem(&1, 0).ctr + elem(&1, 1).ctr)).()
  end

  defp generate_points(specs) do
    {
      generate_points_from_spec(Enum.at(specs, 0)),
      generate_points_from_spec(Enum.at(specs, 1))
    }
  end

  defp generate_points_from_spec(spec, points \\ [], cur \\ %Point{})

  defp generate_points_from_spec(spec, points, _cur)
       when spec == [] or spec == nil do
    points
  end

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

  def find_collisions({points1, points2}) do
    points1_map =
      for point <- points1,
          into: %{},
          do: {Point.get_dimensions(point), point}

    find_collisions_in_map(points2, points1_map)
  end

  def find_collisions_in_map(points, map, collisions \\ [])

  def find_collisions_in_map([], _map, collisions) do
    collisions
  end

  def find_collisions_in_map([point | points], map, collisions) do
    key = Point.get_dimensions(point)

    collisions =
      if Map.has_key?(map, key),
        do: [{point, Map.get(map, key)} | collisions],
        else: collisions

    find_collisions_in_map(points, map, collisions)
  end
end

defmodule SpaceObject do
  @moduledoc """
  A recursively defined tree.
  """

  defstruct [:name, :children]
end

defmodule Day6 do
  @moduledoc """
  Advent of Code 2019
  Day 6: Universal Orbit Map
  """

  def get_orbits() do
    Path.join(__DIR__, "inputs/day6.txt")
    |> File.open!()
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ")"))
  end

  def execute() do
    orbits = get_orbits()

    IO.puts("Part 1: #{part1(orbits)}")
  end

  def part1(orbits) do
    orbits
    |> map_parents_to_children()
    |> construct_tree()
    |> count_orbits()
  end

  def map_parents_to_children(orbits, map \\ %{})

  def map_parents_to_children([], map) do
    map
  end

  def map_parents_to_children([[parent, child] | orbits], map) do
    map = Map.update(map, parent, [child], &[child | &1])

    map_parents_to_children(orbits, map)
  end

  def construct_tree(orbits, object_name \\ "COM") do
    children_names =
      if Map.has_key?(orbits, object_name),
        do: orbits[object_name],
        else: []

    children =
      for child_name <- children_names,
          do: construct_tree(orbits, child_name)

    %SpaceObject{name: object_name, children: children}
  end

  def count_orbits(orbit_tree, depth \\ 1) do
    for(
      child <- orbit_tree.children,
      do: depth + count_orbits(child, depth + 1)
    )
    |> Enum.sum()
  end
end

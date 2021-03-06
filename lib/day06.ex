defmodule Day06.SpaceObject do
  @moduledoc """
  A recursively defined tree.
  """

  defstruct [:name, :children]
end

defmodule Day06 do
  @moduledoc """
  Advent of Code 2019
  Day 6: Universal Orbit Map
  """

  alias Day06.{Part1, Part2}

  def get_orbits() do
    Path.join(__DIR__, "inputs/day06.txt")
    |> File.open!()
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ")"))
  end

  def execute() do
    orbits = get_orbits()

    IO.puts("Part 1: #{Part1.run(orbits)}")
    IO.puts("Part 2: #{Part2.run(orbits)}")
  end
end

defmodule Day06.Part1 do
  alias Day06.SpaceObject

  def run(orbits) do
    orbits
    |> map_parents_to_children()
    |> construct_tree()
    |> count_orbits()
  end

  def map_parents_to_children(orbits, map \\ %{})
  def map_parents_to_children([], map), do: map

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

  def count_orbits(%{children: children} = _orbit_tree, depth \\ 1) do
    for(child <- children, do: depth + count_orbits(child, depth + 1))
    |> Enum.sum()
  end
end

defmodule Day06.Part2 do
  alias Day06.Part1

  def run(orbits) do
    orbits
    |> Part1.map_parents_to_children()
    |> Part1.construct_tree()
    |> calculate_orbital_transfers()
    |> (&elem(&1, 1)).()
  end

  def calculate_orbital_transfers(%{name: name, children: []} = _orbit_tree) do
    if name == "YOU" or name == "SAN", do: {:unconnected, -1}, else: nil
  end

  def calculate_orbital_transfers(%{children: children} = _orbit_tree) do
    child_hops =
      children
      |> Enum.map(fn child ->
        case calculate_orbital_transfers(child) do
          {:connected, _hops} = child_hop -> child_hop
          {:unconnected, hops} -> {:unconnected, hops + 1}
          nil -> nil
        end
      end)
      |> Enum.filter(&(&1 != nil))

    case length(child_hops) do
      0 ->
        nil

      1 ->
        Enum.at(child_hops, 0)

      2 ->
        child_hops
        |> Enum.map(&elem(&1, 1))
        |> Enum.sum()
        |> (&{:connected, &1}).()
    end
  end
end

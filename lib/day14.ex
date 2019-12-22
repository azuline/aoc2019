defmodule Day14 do
  @moduledoc """
  Advent of Code 2019
  Day 14: Space Stoichiometry
  """

  alias Day14.{Part1, Part2}

  def get_reactions() do
    Path.join(__DIR__, "inputs/day14.txt")
    |> File.open!()
    |> IO.stream(:line)
    |> parse_reactions()
  end

  def parse_reactions(lines) do
    lines
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " => "))
    |> Stream.map(fn [left, right] -> [String.split(left, ", "), right] end)
    |> Enum.to_list()
  end

  def execute() do
    reactions = get_reactions()

    IO.puts("Part 1: #{Part1.run(reactions)}")
    IO.puts("Part 2: #{Part2.run(reactions)}")
  end
end

defmodule Day14.Part1 do
  def run(reactions, quantity \\ 1) do
    reactions
    |> transform_reactions_to_map()
    |> calculate_ore_cost("FUEL", quantity)
    |> (&elem(&1, 0)).()
  end

  @doc """
  %{output => {quantity, [{input_quantity, input_elements}, ...]}, ...}
  """
  def transform_reactions_to_map(reactions, map \\ %{})

  def transform_reactions_to_map([], map), do: map

  def transform_reactions_to_map([[inputs, output] | reactions], map) do
    {element, quantity} = parse_element_quantity(output)

    inputs = for inp <- inputs, into: %{}, do: parse_element_quantity(inp)
    map = Map.put(map, element, {quantity, inputs})

    transform_reactions_to_map(reactions, map)
  end

  defp parse_element_quantity(string) do
    string
    |> String.split(" ")
    |> (fn [qty, element] -> {element, String.to_integer(qty)} end).()
  end

  def calculate_ore_cost(reactions, element, qty_needed, leftovers \\ %{})

  def calculate_ore_cost(_, "ORE", qty_needed, leftovers), do: {qty_needed, leftovers}

  def calculate_ore_cost(reactions, element, qty_needed, leftovers) do
    {qty, inputs} = reactions[element]
    {inputs, leftovers} = multiply_qty(inputs, qty, qty_needed, element, leftovers)

    Enum.reduce(inputs, {0, leftovers}, fn {ele, qty}, {ore_cost, leftovers} ->
      {inp_oc, leftovers} = calculate_ore_cost(reactions, ele, qty, leftovers)

      {inp_oc + ore_cost, leftovers}
    end)
  end

  def multiply_qty(inputs, qty, qty_needed, element, leftovers) do
    leftover_element = Map.get(leftovers, element, 0)

    {qty_needed, leftover_element} = {
      max(qty_needed - leftover_element, 0),
      max(leftover_element - qty_needed, 0)
    }

    multiple = ceil(qty_needed / qty)

    leftover_element = leftover_element + (qty * multiple - qty_needed)
    leftovers = Map.put(leftovers, element, leftover_element)

    inputs =
      for inp <- inputs,
          into: %{},
          do: inp |> (fn {ele, qty} -> {ele, qty * multiple} end).()

    subtract_leftovers_from_inputs(inputs, leftovers)
  end

  defp subtract_leftovers_from_inputs(inputs, leftovers) do
    Enum.reduce(inputs, {inputs, leftovers}, fn {ele, qty}, {inputs, leftovers} ->
      leftover_amt = Map.get(leftovers, ele, 0)

      {
        Map.put(inputs, ele, max(qty - leftover_amt, 0)),
        Map.put(leftovers, ele, max(leftover_amt - qty, 0))
      }
    end)
  end
end

defmodule Day14.Part2 do
  alias Day14.Part1

  def run(reactions) do
    reactions
    |> bsearch_ore_cost(1_000_000_000_000)
  end

  def bsearch_ore_cost(reactions, target, low \\ 0, high \\ 1_000_000_000) do
    mid = trunc(low + (high - low) / 2)

    ore_cost = Part1.run(reactions, mid)

    cond do
      ore_cost == target or (ore_cost < target and mid + 1 == high) ->
        mid

      ore_cost < target ->
        bsearch_ore_cost(reactions, target, mid, high)

      ore_cost > target ->
        bsearch_ore_cost(reactions, target, low, mid)
    end
  end
end

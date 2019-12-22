defmodule Day14 do
  @moduledoc """
  Advent of Code 2019
  Day 14: Space Stoichiometry
  """

  alias Day14.Part1

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
  end
end

defmodule Day14.Part1 do
  def run(reactions) do
    reactions
    |> transform_reactions_to_map()
    |> calculate_ore_cost("FUEL", 1)
    |> (&elem(&1, 0)).()
  end

  @doc """
  %{output => {quantity, [{input_quantity, input_elements}, ...]}, ...}
  """
  def transform_reactions_to_map(reactions, map \\ %{})

  def transform_reactions_to_map([], map), do: map

  def transform_reactions_to_map([[inputs, output] | reactions], map) do
    {o_element, o_quantity} = parse_element_quantity(output)
    inputs = for inp <- inputs, into: %{}, do: parse_element_quantity(inp)
    map = Map.put(map, o_element, {o_quantity, inputs})
    transform_reactions_to_map(reactions, map)
  end

  def calculate_ore_cost(reactions, element, qty_needed, leftovers \\ %{})

  def calculate_ore_cost(_, "ORE", qty_needed, leftovers), do: {qty_needed, leftovers}

  def calculate_ore_cost(reactions, element, qty_needed, leftovers) do
    {qty, inputs} = reactions[element]
    {inputs, leftovers} = multiply_qty(inputs, qty, qty_needed, element, leftovers)

    Enum.reduce(inputs, {0, leftovers}, fn {i_ele, i_qty}, {ore_cost, leftovers} ->
      {inp_ore_cost, leftovers} = calculate_ore_cost(reactions, i_ele, i_qty, leftovers)

      {ore_cost + inp_ore_cost, leftovers}
    end)
  end

  def multiply_qty(inputs, qty, qty_needed, element, leftovers) do
    leftover_element = Map.get(leftovers, element, 0)

    new_qty_needed = max(qty_needed - leftover_element, 0)
    multiple = ceil(new_qty_needed / qty)

    leftover_element = max(leftover_element - qty_needed, 0) + (qty * multiple - new_qty_needed)

    inputs =
      Enum.reduce(inputs, %{}, fn {ele, qty}, inputs ->
        Map.put(inputs, ele, qty * multiple)
      end)

    leftovers = Map.put(leftovers, element, leftover_element)

    Enum.reduce(inputs, {inputs, leftovers}, fn {ele, qty}, {inputs, leftovers} ->
      leftover_amt = Map.get(leftovers, ele, 0)

      inputs = Map.put(inputs, ele, max(qty - leftover_amt, 0))
      leftovers = Map.put(leftovers, ele, max(leftover_amt - qty, 0))

      {inputs, leftovers}
    end)
  end

  defp parse_element_quantity(string) do
    string
    |> String.split(" ")
    |> (fn [qty, element] -> {element, String.to_integer(qty)} end).()
  end
end

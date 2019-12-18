defmodule Day11 do
  @moduledoc """
  Advent of Code 2019
  Day 11: Space Police
  """

  def get_program() do
    Path.join(__DIR__, "inputs/day11.txt")
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def execute() do
    program = get_program()

    IO.puts("Part 1: #{part1(program)}")
    IO.puts("Part 2:\n#{part2(program)}")
  end

  def part1(program) do
    GenServer.start_link(IntCode, program, name: Computer)
    panels = run_painting_robot()
    GenServer.stop(Computer)
    map_size(panels)
  end

  def part2(program) do
    GenServer.start_link(IntCode, program, name: Computer)
    panels = run_painting_robot(%{{0, 0} => 1})
    GenServer.stop(Computer)
    format_panels(panels)
  end

  # black = 0, white = 1

  @cw_rotations %{:up => :right, :right => :down, :down => :left, :left => :up}
  @ccw_rotations %{:up => :left, :left => :down, :down => :right, :right => :up}

  def run_painting_robot(panels \\ %{}, {x, y} = coords \\ {0, 0}, direction \\ :up) do
    input = Map.get(panels, coords, 0)

    case GenServer.call(Computer, {:run, [input]}) do
      {:exit, _} ->
        panels

      {:output, color} ->
        panels = Map.put(panels, coords, color)

        direction =
          case GenServer.call(Computer, {:run, []}) do
            {_, 0} -> @cw_rotations[direction]
            {_, 1} -> @ccw_rotations[direction]
          end

        coords =
          case direction do
            :up -> {x, y + 1}
            :right -> {x + 1, y}
            :down -> {x, y - 1}
            :left -> {x - 1, y}
          end

        run_painting_robot(panels, coords, direction)
    end
  end

  def format_panels(panels) do
    dimensions = get_dimensions(panels)

    for y <- dimensions.y_max..dimensions.y_min do
      for x <- dimensions.x_max..dimensions.x_min do
        case Map.get(panels, {x, y}, 0) do
          0 -> "  "
          1 -> "\u2591\u2591"
        end
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
  end

  defp get_dimensions(panels) do
    panels_list = Map.to_list(panels)

    x_coords = Enum.map(panels_list, &elem(elem(&1, 0), 0))
    y_coords = Enum.map(panels_list, &elem(elem(&1, 0), 1))

    %{
      x_min: Enum.min(x_coords),
      x_max: Enum.max(x_coords),
      y_min: Enum.min(y_coords),
      y_max: Enum.max(y_coords)
    }
  end
end

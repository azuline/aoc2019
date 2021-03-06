defmodule Day11 do
  @moduledoc """
  Advent of Code 2019
  Day 11: Space Police
  """

  alias Day11.{Part1, Part2}

  def get_program() do
    Path.join(__DIR__, "inputs/day11.txt")
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def execute() do
    program = get_program()

    IO.puts("Part 1: #{Part1.run(program)}")
    IO.puts("Part 2:\n#{Part2.run(program)}")
  end
end

defmodule Day11.Part1 do
  def run(program) do
    GenServer.start_link(Intcode, program, name: Computer11)
    panels = run_painting_robot()
    GenServer.stop(Computer11)
    map_size(panels)
  end

  # black = 0, white = 1

  @cw_rotations %{:up => :right, :right => :down, :down => :left, :left => :up}
  @ccw_rotations %{:up => :left, :left => :down, :down => :right, :right => :up}

  def run_painting_robot(panels \\ %{}, {x, y} = coords \\ {0, 0}, direction \\ :up) do
    input = Map.get(panels, coords, 0)

    case GenServer.call(Computer11, {:run, [input]}) do
      {:exit, _} ->
        panels

      {:output, color} ->
        panels = Map.put(panels, coords, color)

        direction =
          case GenServer.call(Computer11, {:run, []}) do
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
end

defmodule Day11.Part2 do
  alias Day11.Part1

  def run(program) do
    GenServer.start_link(Intcode, program, name: Computer11)
    panels = Part1.run_painting_robot(%{{0, 0} => 1})
    GenServer.stop(Computer11)
    format_panels(panels)
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

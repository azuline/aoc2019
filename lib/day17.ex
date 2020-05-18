defmodule Day17 do
  @moduledoc """
  Advent of Code 2019
  Day 17: Set and Forget
  """

  alias Day17.{Part1, Part2}

  def get_program() do
    Path.join(__DIR__, "inputs/day17.txt")
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def execute() do
    program = get_program()

    program
    |> Part1.compute_camera_output()
    |> (&to_string/1).()
    |> IO.puts()

    IO.puts("Part 1: #{Part1.run(program)}")
    IO.puts("Part 2: #{Part2.run(program)}")
  end
end

defmodule Day17.Part1 do
  import Intcode, only: [run_computer: 2]

  def run(program) do
    program
    |> compute_camera_output()
    |> convert_to_coords()
    |> compute_alignment_parameters()
    |> Stream.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  def compute_camera_output(program) do
    GenServer.start_link(Intcode, program, name: Computer17)
    output = accumulate_output()
    GenServer.stop(Computer17)
    output
  end

  def accumulate_output(computer_name \\ Computer17) do
    case GenServer.call(computer_name, {:run, []}) do
      {:exit, _} -> []
      {:output, code} -> [code | accumulate_output(computer_name)]
    end
  end

  def convert_to_coords(scaffolding) do
    # Treating everything besides a dot and a newline as scaffolding.

    scaffolding
    |> Enum.reduce({MapSet.new(), {0, 0}}, fn char, {coords, {x, y}} ->
      case char do
        c when c in [?#, ?^, ?>, ?v, ?<] -> {MapSet.put(coords, {x, y}), {x + 1, y}}
        ?. -> {coords, {x + 1, y}}
        ?\n -> {coords, {0, y + 1}}
      end
    end)
    |> (&elem(&1, 0)).()
  end

  def compute_alignment_parameters(coords) do
    coords
    |> Enum.filter(fn {x, y} ->
      [{x - 1, y}, {x, y + 1}, {x + 1, y}, {x, y - 1}]
      |> Enum.all?(fn neighbor -> MapSet.member?(coords, neighbor) end)
    end)
  end
end

defmodule Day17.Part2 do
  alias Day17.Part1

  def run(program) do
    GenServer.start_link(Intcode, program, name: Computer17_2)
    output = Part1.accumulate_output(Computer17_2)

    start_coord = output |> get_start_coord()
    coords = output |> Part1.convert_to_coords()

    space_dust =
      compute_path(start_coord, coords)
      |> split_path_into_functions()
      |> execute_robot()

    GenServer.stop(Computer17_2)

    space_dust
  end

  def get_start_coord([char | scaffolding], {x, y} \\ {0, 0}) do
    case char do
      ?^ -> {{x, y}, :up}
      ?> -> {{x, y}, :right}
      ?v -> {{x, y}, :down}
      ?< -> {{x, y}, :left}
      c when c in [?#, ?.] -> get_start_coord(scaffolding, {x + 1, y})
      ?\n -> get_start_coord(scaffolding, {x, y + 1})
    end
  end

  def compute_path({start_coord, start_dir}, coords) do
    opposite_dir = compute_opposite_dir(start_dir)
    prev_coord = move_coord(start_coord, opposite_dir)

    case find_next_direction(start_coord, coords, prev_coord) do
      nil ->
        []

      adja_dir ->
        turn = compute_turning_direction(start_dir, adja_dir)
        {new_coord, dist} = compute_walking_distance(start_coord, adja_dir, coords)

        turn ++ [dist | compute_path({new_coord, adja_dir}, coords)]
    end
  end

  def find_next_direction({x, y}, coords, prev_coord) do
    [:up, :right, :down, :left]
    |> Enum.find(fn dir ->
      adja_coord = move_coord({x, y}, dir)
      MapSet.member?(coords, adja_coord) && prev_coord != adja_coord
    end)
  end

  @dir_num_vals %{
    :up => 0,
    :right => 1,
    :down => 2,
    :left => 3
  }

  def compute_turning_direction(start_dir, adja_dir) do
    diff =
      (@dir_num_vals[adja_dir] - @dir_num_vals[start_dir])
      |> Integer.mod(4)

    case diff do
      0 -> []
      1 -> ["R"]
      2 -> ["R", "R"]
      3 -> ["L"]
    end
  end

  def compute_walking_distance({x, y}, dir, coords, dist \\ 0) do
    new_coord = move_coord({x, y}, dir)

    if !MapSet.member?(coords, new_coord) do
      {{x, y}, dist}
    else
      compute_walking_distance(new_coord, dir, coords, dist + 1)
    end
  end

  def split_path_into_functions(path) do
    # TODO
    nil
  end

  def execute_robot({main, functions}) do
    # TODO
    nil
  end

  def move_coord({x, y}, dir) do
    case dir do
      :up -> {x, y - 1}
      :right -> {x + 1, y}
      :down -> {x, y + 1}
      :left -> {x - 1, y}
    end
  end

  def compute_opposite_dir(dir) do
    case dir do
      :up -> :down
      :down -> :up
      :right -> :left
      :left -> :right
    end
  end
end
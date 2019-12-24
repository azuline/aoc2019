defmodule Day15 do
  @moduledoc """
  Advent of Code 2019
  Day 15: Oxygen System
  """

  alias Day15.{Part1, Part2}

  def get_program() do
    Path.join(__DIR__, "inputs/day15.txt")
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def execute() do
    program = get_program()

    IO.puts("Part 1: #{Part1.run(program)}")
    IO.puts("Part 2: #{Part2.run(program)}")
  end
end

defmodule Queue do
  def new(), do: :queue.new()
  def enq(queue, val), do: :queue.in(val, queue)
  def deq(queue), do: :queue.out(queue)
  def empty?(queue), do: :queue.is_empty(queue)
end

defmodule Day15.Part1 do
  def run(program) do
    program
    |> queue_initial_coords()
    |> find_path_to_oxygen_system()
    |> (&elem(&1, 0)).()
    |> length()
  end

  def queue_initial_coords(program, {x, y} \\ {0, 0}) do
    Queue.new()
    |> Queue.enq({[1], {x, y + 1}, %{program: program}})
    |> Queue.enq({[2], {x, y - 1}, %{program: program}})
    |> Queue.enq({[3], {x - 1, y}, %{program: program}})
    |> Queue.enq({[4], {x + 1, y}, %{program: program}})
  end

  def find_path_to_oxygen_system(discovered, visited \\ MapSet.new()) do
    {{:value, {series, coords, program_state}}, discovered} = Queue.deq(discovered)

    direction = List.first(series)
    visited = MapSet.put(visited, coords)

    case run_repair_droid(direction, program_state) do
      {0, _} ->
        find_path_to_oxygen_system(discovered, visited)

      {1, program_state} ->
        queue_newly_discovered(discovered, visited, direction, series, coords, program_state)
        |> find_path_to_oxygen_system(visited)

      {2, program_state} ->
        {series, {coords, program_state}}
    end
  end

  @opposites %{1 => 2, 2 => 1, 3 => 4, 4 => 3}

  def queue_newly_discovered(discovered, visited, direction, series, coords, program_state) do
    [1, 2, 3, 4]
    |> List.delete(@opposites[direction])
    |> Enum.map(fn next_direction ->
      new_coords = move_coords(coords, next_direction)

      if not MapSet.member?(visited, new_coords),
        do: {[next_direction | series], new_coords, program_state},
        else: nil
    end)
    |> Enum.reject(&(&1 == nil))
    |> Enum.reduce(discovered, &Queue.enq(&2, &1))
  end

  def run_repair_droid(direction, program_state) do
    GenServer.start_link(Intcode, [], name: RepairDroid)
    GenServer.call(RepairDroid, {:set_state, program_state})

    {:output, status} = GenServer.call(RepairDroid, {:run, [direction]})
    state = GenServer.call(RepairDroid, {:get_state})

    GenServer.stop(RepairDroid)

    {status, state}
  end

  defp move_coords({x, y}, direction) do
    case direction do
      1 -> {x, y + 1}
      2 -> {x, y - 1}
      3 -> {x - 1, y}
      4 -> {x + 1, y}
    end
  end
end

defmodule Day15.Part2 do
  alias Day15.Part1

  def run(program) do
    {oxygen_coords, %{program: program}} =
      program
      |> Part1.queue_initial_coords()
      |> Part1.find_path_to_oxygen_system()
      |> (&elem(&1, 1)).()

    program
    |> Part1.queue_initial_coords(oxygen_coords)
    |> find_longest_path(MapSet.new([oxygen_coords]))
    |> length()
  end

  @doc """
  A BFS traversal where we return the last (and longest, by BFS definition) path
  from the oxygen tank to a coordinate in the area.
  """
  def find_longest_path(discovered, visited) do
    {{:value, {series, coords, program_state}}, discovered} = Queue.deq(discovered)

    [direction | series_tail] = series

    {code, program_state} = Part1.run_repair_droid(direction, program_state)

    discovered =
      case code do
        0 ->
          discovered

        1 ->
          Part1.queue_newly_discovered(
            discovered,
            visited,
            direction,
            series,
            coords,
            program_state
          )
      end

    visited = MapSet.put(visited, coords)

    if Queue.empty?(discovered),
      do: if(code == 1, do: series, else: series_tail),
      else: find_longest_path(discovered, visited)
  end
end

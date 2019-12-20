defmodule Day13 do
  @moduledoc """
  Advent of Code 2019
  Day 13: Care Package
  """

  alias Day13.{Part1, Part2}

  def get_program() do
    Path.join(__DIR__, "inputs/day13.txt")
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

defmodule Day13.Part1 do
  def run(program) do
    GenServer.start_link(IntCode, program, name: Computer)
    tiles = generate_tiles()
    GenServer.stop(Computer)
    num_blocks(tiles)
  end

  def generate_tiles(tiles \\ %{}) do
    case GenServer.call(Computer, {:run, []}) do
      {:exit, _} ->
        tiles

      {:output, x} ->
        {:output, y} = GenServer.call(Computer, {:run, []})
        {:output, type} = GenServer.call(Computer, {:run, []})

        generate_tiles(Map.put(tiles, {x, y}, type))
    end
  end

  defp num_blocks(tiles) do
    tiles
    |> Map.to_list()
    |> Enum.filter(fn {_coords, type} -> type == 2 end)
    |> length()
  end
end

defmodule Day13.Part2 do
  def run(program) do
    program = List.replace_at(program, 0, 2)
    GenServer.start_link(IntCode, program, name: Computer)
    score = play_game()
    GenServer.stop(Computer)
    score
  end

  def play_game(paddle \\ {0, 0}, ball \\ {0, 0}, score \\ 0) do
    input = determine_input(paddle, ball)

    case GenServer.call(Computer, {:run, [input]}) do
      {:exit, _} ->
        score

      {:output, x} ->
        {:output, y} = GenServer.call(Computer, {:run, []})
        {:output, type} = GenServer.call(Computer, {:run, []})

        case {x, y, type} do
          {-1, 0, score} ->
            play_game(paddle, ball, score)

          {x, y, 3} ->
            play_game({x, y}, ball, score)

          {x, y, 4} ->
            play_game(paddle, {x, y}, score)

          _ ->
            play_game(paddle, ball, score)
        end
    end
  end

  defp determine_input({paddle, _}, {ball, _}) do
    cond do
      paddle < ball -> 1
      paddle == ball -> 0
      paddle > ball -> -1
    end
  end
end

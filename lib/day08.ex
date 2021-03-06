defmodule Day08 do
  @moduledoc """
  Advent of Code 2019
  Day 8: Space Image Format
  """

  alias Day08.{Part1, Part2}

  def get_image() do
    Path.join(__DIR__, "inputs/day08.txt")
    |> File.read!()
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def execute() do
    image = get_image()

    IO.puts("Part 1: #{Part1.run(image)}")
    IO.puts("Part 2:\n#{Part2.run(image)}")
  end
end

defmodule Day08.Part1 do
  def run(image) do
    image
    |> Enum.chunk_every(150)
    |> Enum.max_by(&Enum.count(&1, fn e -> e != 0 end))
    |> (&(Enum.count(&1, fn e -> e == 1 end) * Enum.count(&1, fn e -> e == 2 end))).()
  end
end

defmodule Day08.Part2 do
  def run(image) do
    [image | chunks] = Enum.chunk_every(image, 150)

    Enum.reduce(chunks, image, fn chunk, image ->
      Enum.zip([chunk, image])
      |> Enum.map(fn {c, i} -> if i == 2, do: c, else: i end)
    end)
    |> Enum.map(&if &1 == 0, do: "  ", else: "\u2591\u2591")
    |> break_into_lines(25)
  end

  defp break_into_lines(image, line_width) do
    image
    |> Enum.chunk_every(line_width)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
  end
end

defmodule Day16 do
  @moduledoc """
  Advent of Code 2019
  Day 16: Flawed Frequency Transmission
  """

  alias Day16.Part1

  def get_signal() do
    Path.join(__DIR__, "inputs/day16.txt")
    |> File.read!()
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def execute() do
    signal = get_signal()

    IO.puts("Part 1: #{Part1.run(signal)}")
  end
end

defmodule Day16.Part1 do
  def run(signal) do
    Enum.reduce(1..100, signal, fn _, signal -> run_fft_algo(signal) end)
    |> Enum.take(8)
    |> Enum.join()
  end

  def run_fft_algo(signal) do
    Enum.map(1..length(signal), fn row ->
      signal
      |> Enum.with_index(1)
      |> Enum.map(fn {digit, col} -> digit * get_coefficient(row, col) end)
      |> Enum.sum()
      |> abs()
      |> Integer.mod(10)
    end)
  end

  def get_coefficient(row, col) do
    case Integer.mod(div(col, row), 4) do
      0 -> 0
      1 -> 1
      2 -> 0
      3 -> -1
    end
  end
end

defmodule Day16 do
  @moduledoc """
  Advent of Code 2019
  Day 16: Flawed Frequency Transmission
  """

  alias Day16.{Part1, Part2}

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
    IO.puts("Part 2: #{Part2.run(signal)}")
  end
end

defmodule Day16.Part1 do
  def run(signal) do
    Enum.reduce(1..100, signal, fn _, signal -> run_fft_algo(signal) end)
    |> Enum.take(8)
    |> Enum.join()
    |> String.to_integer()
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

defmodule Day16.Part2 do
  @moduledoc """
  It is clearly not feasible to actually brute force the FFT with 10000
  repetitions of the input, considering that the calculation is O(n^2).

  There are 651 characters in the input. That means our "real" input signal has
  6_510_000 digits. The first seven digits of our input, aka our offset, are
  5_977_341.

  What is notable is that the latter half of the signal can be computed quickly
  in reverse via partial sums, because the coefficients are always `1`.
  Furthermore, in the latter half, each digit in the output only relies on the
  digits after its position in the input. Since the offset is in the second
  half of the signal, we can save on some annoying computations.
  """

  def run(signal) do
    full_signal =
      signal
      |> List.duplicate(10000)
      |> List.flatten()
      |> Enum.drop(signal |> get_offset())

    Enum.reduce(1..100, full_signal, fn _, signal -> rtl_prefix_sums(signal) end)
    |> Enum.take(8)
    |> Enum.join()
    |> String.to_integer()
  end

  def get_offset(signal) do
    signal
    |> Enum.take(7)
    |> Enum.join()
    |> String.to_integer()
  end

  def rtl_prefix_sums(signal) do
    signal
    |> Enum.reverse()
    |> Enum.reduce({[], 0}, fn digit, {prefixes, sum} ->
      new_sum = (digit + sum) |> Integer.mod(10)

      {[new_sum | prefixes], new_sum}
    end)
    |> (&elem(&1, 0)).()
  end
end

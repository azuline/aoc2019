defmodule Day16Test do
  use ExUnit.Case, async: true

  import Day16
  alias Day16.{Part1, Part2}

  # Takes a few seconds to run.

  # test "part 1" do
  #   assert 12541048 == get_signal() |> Part1.run()
  # end

  test "part 1 example 1" do
    digits =
      "80871224585914546619083218645595"
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    assert 24_176_176 == digits |> Part1.run()
  end

  test "part 2 example 1" do
    digits =
      "03036732577212944063491565474664"
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    assert 84_462_026 == digits |> Part2.run()
  end
end

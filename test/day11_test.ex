defmodule Day11Test do
  use ExUnit.Case, async: true

  import Day11

  test "part 1" do
    assert 1964 == get_program() |> part1()
  end

  test "part 2" do
    answer =
      Enum.join(
        [
          "  ░░░░░░░░  ░░    ░░  ░░░░░░░░  ░░    ░░    ░░░░    ░░░░░░░░  ░░░░░░    ░░    ░░      ",
          "  ░░        ░░  ░░    ░░        ░░  ░░    ░░    ░░  ░░        ░░    ░░  ░░  ░░        ",
          "  ░░░░░░    ░░░░      ░░░░░░    ░░░░      ░░        ░░░░░░    ░░    ░░  ░░░░          ",
          "  ░░        ░░  ░░    ░░        ░░  ░░    ░░        ░░        ░░░░░░    ░░  ░░        ",
          "  ░░        ░░  ░░    ░░        ░░  ░░    ░░    ░░  ░░        ░░  ░░    ░░  ░░        ",
          "  ░░        ░░    ░░  ░░░░░░░░  ░░    ░░    ░░░░    ░░        ░░    ░░  ░░    ░░      "
        ],
        "\n"
      )

    assert answer == get_program() |> part2()
  end
end

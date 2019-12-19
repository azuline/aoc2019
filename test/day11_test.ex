defmodule Day11Test do
  use ExUnit.Case, async: true

  import Day11
  alias Day11.{Part1, Part2}

  test "part 1" do
    assert 1964 == get_program() |> Part1.run()
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

    assert answer == get_program() |> Part2.run()
  end
end

defmodule Day08Test do
  use ExUnit.Case, async: true

  import Day08
  alias Day08.{Part1, Part2}

  test "part 1" do
    assert 2286 == get_image() |> Part1.run()
  end

  test "part 2" do
    letters =
      Enum.join(
        [
          "  ░░░░        ░░░░  ░░░░░░░░  ░░        ░░░░░░    ",
          "░░    ░░        ░░        ░░  ░░        ░░    ░░  ",
          "░░              ░░      ░░    ░░        ░░    ░░  ",
          "░░              ░░    ░░      ░░        ░░░░░░    ",
          "░░    ░░  ░░    ░░  ░░        ░░        ░░        ",
          "  ░░░░      ░░░░    ░░░░░░░░  ░░░░░░░░  ░░        "
        ],
        "\n"
      )

    assert letters == get_image() |> Part2.run()
  end
end

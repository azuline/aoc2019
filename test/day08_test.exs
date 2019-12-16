defmodule Day08Test do
  use ExUnit.Case, async: true

  import Day08

  @part2_letters Enum.join(
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

  test "part 1" do
    assert 2286 == get_image() |> part1()
  end

  test "part 2" do
    assert @part2_letters == get_image() |> part2()
  end
end

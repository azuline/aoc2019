defmodule Day02Test do
  use ExUnit.Case, async: true

  import Day02
  alias Day02.{Part1, Part2}

  test "part 1" do
    assert 3_166_704 == get_program() |> Part1.run()
  end

  test "part 2" do
    assert 8018 == get_program() |> Part2.run()
  end

  test "example" do
    output =
      [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]
      |> Part1.run_program()
      |> List.first()

    assert output == 3500
  end
end

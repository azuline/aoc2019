defmodule Day02Test do
  use ExUnit.Case, async: true

  import Day02

  test "part 1" do
    assert 3_166_704 == get_program() |> part1()
  end

  test "part 2" do
    assert 8018 == get_program() |> part2()
  end

  test "example" do
    output =
      [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]
      |> run_program()
      |> List.first()

    assert output == 3500
  end
end

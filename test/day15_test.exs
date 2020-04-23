defmodule Day15Test do
  use ExUnit.Case, async: true

  import Day15
  alias Day15.{Part1, Part2}

  test "part 1" do
    assert 262 == get_program() |> Part1.run()
  end

  test "part 2" do
    assert 314 == get_program() |> Part2.run()
  end
end

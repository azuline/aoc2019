defmodule Day13Test do
  use ExUnit.Case, async: true

  import Day13
  alias Day13.{Part1, Part2}

  test "part 1" do
    assert 251 == get_program() |> Part1.run()
  end

  # Takes a while to simulate the game.

  # test "part 2" do
  #   assert 12779 == get_program() |> Part2.run()
  # end
end

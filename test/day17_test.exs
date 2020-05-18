defmodule Day17Test do
  use ExUnit.Case, async: true

  import Day17
  alias Day17.{Part1, Part2}

  test "part 1" do
    assert 3336 == get_program() |> Part1.run()
  end
end

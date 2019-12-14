defmodule Day5Test do
  use ExUnit.Case, async: true

  import Day5

  test "part 1" do
    output =
      get_program()
      |> part1()

    assert output == 11_193_703
  end
end

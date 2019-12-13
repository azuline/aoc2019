defmodule Day2Test do
  use ExUnit.Case, async: true

  import Day2

  test "test run program" do
    output =
      [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]
      |> run_program()
      |> List.first()

    assert output == 3500
  end
end

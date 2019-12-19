defmodule Day01Test do
  use ExUnit.Case, async: true

  import Day01
  alias Day01.{Part1, Part2}

  test "part 1" do
    assert 3_360_301 == get_masses() |> Part1.run()
  end

  test "part 2" do
    assert 5_037_595 == get_masses() |> Part2.run()
  end

  test "part 1 example" do
    assert Part1.run([14, 1969]) == 656
  end

  test "fuel of mass calculator 14" do
    assert Part1.calculate_fuel(14) == 2
  end

  test "fuel of mass calculator 1969" do
    assert Part1.calculate_fuel(1969) == 654
  end

  test "part 2 example" do
    assert Part2.run([14, 1969]) == 968
  end

  test "fuel of fuel calculator 14" do
    assert Part2.calculate_fuel(14) == 2
  end

  test "fuel of fuel calculator 1969" do
    assert Part2.calculate_fuel(1969) == 966
  end
end

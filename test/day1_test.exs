defmodule Day1Test do
  use ExUnit.Case, async: true

  import Day1

  test "fuel of mass calculator 14" do
    assert fuel_of_mass_calculator(14) == 2
  end

  test "fuel of mass calculator 1969" do
    assert fuel_of_mass_calculator(1969) == 654
  end

  test "part 1" do
    assert part1([14, 1969]) == 656
  end

  test "fuel of fuel calculator 14" do
    assert fuel_of_fuel_calculator(14) == 2
  end

  test "fuel of fuel calculator 1969" do
    assert fuel_of_fuel_calculator(1969) == 966
  end

  test "part 2" do
    assert part2([14, 1969]) == 968
  end
end

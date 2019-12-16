defmodule Day01Test do
  use ExUnit.Case, async: true

  import Day01

  test "part 1" do
    assert 3_360_301 == get_masses() |> part1()
  end

  test "part 2" do
    assert 5_037_595 == get_masses() |> part2()
  end

  test "part 1 example" do
    assert part1([14, 1969]) == 656
  end

  test "fuel of mass calculator 14" do
    assert fuel_of_mass_calculator(14) == 2
  end

  test "fuel of mass calculator 1969" do
    assert fuel_of_mass_calculator(1969) == 654
  end

  test "part 2 example" do
    assert part2([14, 1969]) == 968
  end

  test "fuel of fuel calculator 14" do
    assert fuel_of_fuel_calculator(14) == 2
  end

  test "fuel of fuel calculator 1969" do
    assert fuel_of_fuel_calculator(1969) == 966
  end
end

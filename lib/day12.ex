defmodule Day12.Moon do
  defstruct position: %{x: 0, y: 0, z: 0},
            velocity: %{x: 0, y: 0, z: 0}

  @pattern ~r/<x=(?<x>-?\d+), y=(?<y>-?\d+), z=(?<z>-?\d+)>/

  def from_line(line) do
    %{"x" => x, "y" => y, "z" => z} = Regex.named_captures(@pattern, line)

    %__MODULE__{
      position: %{
        x: String.to_integer(x),
        y: String.to_integer(y),
        z: String.to_integer(z)
      }
    }
  end
end

defmodule Day12 do
  @moduledoc """
  Advent of Code 2019
  Day 12: The N-Body Problem
  """

  alias Day12.{Part1, Part2, Moon}

  def get_moons() do
    Path.join(__DIR__, "inputs/day12.txt")
    |> File.open!()
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&Moon.from_line/1)
    |> Enum.to_list()
  end

  def execute() do
    moons = get_moons()

    IO.puts("Part 1: #{Part1.run(moons)}")
    IO.puts("Part 2: #{Part2.run(moons)}")
  end
end

defmodule Day12.Part1 do
  alias Day12.Moon

  def run(moons) do
    simulate_steps(moons)
    |> calculate_energy()
  end

  def simulate_steps(moons, limit \\ 1000, ctr \\ 0) do
    if ctr == limit do
      moons
    else
      moons =
        for moon <- moons do
          moon
          |> apply_gravity(moons -- [moon])
          |> apply_velocity()
        end

      simulate_steps(moons, limit, ctr + 1)
    end
  end

  def calculate_energy(moons) do
    moons
    |> Stream.map(fn %Moon{
                       position: %{x: p_x, y: p_y, z: p_z},
                       velocity: %{x: v_x, y: v_y, z: v_z}
                     } ->
      (abs(p_x) + abs(p_y) + abs(p_z)) * (abs(v_x) + abs(v_y) + abs(v_z))
    end)
    |> Enum.sum()
  end

  def calculate_velocity_change(m_axis, o_axis) do
    diff = o_axis - m_axis

    cond do
      diff > 0 -> 1
      diff == 0 -> 0
      diff < 0 -> -1
    end
  end

  defp apply_gravity(moon, other_moons) do
    Enum.reduce(other_moons, moon, fn %Moon{position: o_pos} = _other,
                                      %Moon{position: m_pos, velocity: m_vel} = moon ->
      velocity = %{
        x: m_vel.x + calculate_velocity_change(m_pos.x, o_pos.x),
        y: m_vel.y + calculate_velocity_change(m_pos.y, o_pos.y),
        z: m_vel.z + calculate_velocity_change(m_pos.z, o_pos.z)
      }

      %Moon{moon | velocity: velocity}
    end)
  end

  defp apply_velocity(
         %Moon{
           position: %{x: p_x, y: p_y, z: p_z},
           velocity: %{x: v_x, y: v_y, z: v_z}
         } = moon
       ) do
    %Moon{moon | position: %{x: p_x + v_x, y: p_y + v_y, z: p_z + v_z}}
  end
end

defmodule Day12.Part2 do
  alias Day12.Part1

  def run(moons) do
    # Sort of tricky problem.
    #
    # Since the state of the moons solely relies upon the previous state, it is
    # guaranteed that we will return to the initial state first. Thus, we only
    # need to check to see when the initial state is reached again.
    #
    # Also, the movements of the x, y, and z coordinates are independent of
    # each other. Thus, we can just find the cycle period for each of the three
    # axes, then take their least common multiple.

    moons
    |> get_cycles_of_axes()
    |> compute_lcm()
  end

  def get_cycles_of_axes(moons) do
    %{
      x: get_cycle_of_axis(moons, :x),
      y: get_cycle_of_axis(moons, :y),
      z: get_cycle_of_axis(moons, :z)
    }
  end

  def get_cycle_of_axis(moons, axis) do
    moons =
      for moon <- moons,
          do: %{
            position: moon.position[axis],
            velocity: moon.velocity[axis]
          }

    get_cycle_of_axis(moons, 0, moons)
  end

  def get_cycle_of_axis(moons, ctr, target) do
    if ctr != 0 and moons == target do
      ctr
    else
      moons =
        for moon <- moons do
          moon
          |> apply_gravity_to_axis(moons -- [moon])
          |> apply_velocity_to_axis()
        end

      get_cycle_of_axis(moons, ctr + 1, target)
    end
  end

  defp apply_gravity_to_axis(moon, other_moons) do
    Enum.reduce(other_moons, moon, fn %{position: o_pos} = _other,
                                      %{position: m_pos, velocity: m_vel} = moon ->
      %{moon | velocity: m_vel + Part1.calculate_velocity_change(m_pos, o_pos)}
    end)
  end

  defp apply_velocity_to_axis(%{position: pos, velocity: vel} = moon) do
    %{moon | position: pos + vel}
  end

  defp compute_lcm(%{x: x, y: y, z: z}), do: lcm(x, lcm(y, z))

  defp lcm(x, y), do: trunc(x * y / Integer.gcd(x, y))
end

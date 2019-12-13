defmodule Day4 do
  @moduledoc """
  Advent of Code 2019
  Day 4: Secure Container
  """

  def part1() do
    [lower, upper] = get_range()

    calculate_number_of_valid_passwords(lower, upper)
  end

  def part2() do
    [lower, upper] = get_range()

    calculate_number_of_valid_passwords(lower, upper, &exactly_2_adjacent?/2)
  end

  defp get_range() do
    Path.join(__DIR__, "inputs/day4.txt")
    |> File.read!()
    |> String.trim()
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end

  # Recursively iterate through all numbers between the lower and upper bounds.
  # The lower bound is passed in as the `password` parameter, and is
  # incremented until it equals the upper bound. For each password, check if
  # it's valid, and increment a counter based on the result.

  defp calculate_number_of_valid_passwords(
         password,
         upper_bound,
         adjacency_check \\ &adjacent?/2,
         num_valid \\ 0
       )

  defp calculate_number_of_valid_passwords(password, upper_bound, _adjacency_check, num_valid)
       when password == upper_bound,
       do: num_valid

  defp calculate_number_of_valid_passwords(password, upper_bound, adjacency_check, num_valid),
    do:
      calculate_number_of_valid_passwords(
        password + 1,
        upper_bound,
        adjacency_check,
        if(valid_password?(password, adjacency_check),
          do: num_valid + 1,
          else: num_valid
        )
      )

  # Recursively process each digit of the password to check if it's valid.
  # First, transform the password into a list of its digits. Then check each
  # digit to see if it makes a password invalid. We don't check 6-digit-ness
  # because the range already restricts passwords to 6-digits.

  defp valid_password?(
         password,
         adjacency_check,
         index \\ 0,
         adjacent_same \\ false
       )

  defp valid_password?(password, adjacency_check, index, adjacent_same)
       when is_number(password),
       do:
         valid_password?(
           split_password(password),
           adjacency_check,
           index,
           adjacent_same
         )

  defp valid_password?(digits, _adjacency_check, index, adjacent_same)
       when length(digits) == index,
       do: adjacent_same

  defp valid_password?(digits, adjacency_check, 0, adjacent_same),
    do: valid_password?(digits, adjacency_check, 1, adjacent_same)

  defp valid_password?(digits, adjacency_check, index, adjacent_same) do
    if Enum.at(digits, index) >= Enum.at(digits, index - 1),
      do:
        valid_password?(
          digits,
          adjacency_check,
          index + 1,
          adjacent_same or adjacency_check.(digits, index)
        ),
      else: false
  end

  # Part 1: Check to see if the digit prior to the current digit and the
  # current digit are equivalent.

  defp adjacent?(_digits, index) when index == 0, do: false

  defp adjacent?(digits, index),
    do: Enum.at(digits, index) == Enum.at(digits, index - 1)

  # Part 2: Check to see if the digit prior to the current digit and the
  # current digit are equivalent, and ensure that they are not part of a larger
  # group of matching digits.

  defp exactly_2_adjacent?(_digits, index) when index == 0, do: false

  defp exactly_2_adjacent?(digits, index) when index == 1 do
    cur_digit = Enum.at(digits, index)

    cur_digit == Enum.at(digits, index - 1) and
      cur_digit != Enum.at(digits, index + 1)
  end

  defp exactly_2_adjacent?(digits, index) when length(digits) - 1 == index do
    cur_digit = Enum.at(digits, index)

    cur_digit == Enum.at(digits, index - 1) and
      cur_digit != Enum.at(digits, index - 2)
  end

  defp exactly_2_adjacent?(digits, index) do
    cur_digit = Enum.at(digits, index)

    cur_digit == Enum.at(digits, index - 1) and
      cur_digit != Enum.at(digits, index + 1) and
      cur_digit != Enum.at(digits, index - 2)
  end

  # Split a password into a list of its digits.

  defp split_password(password) when password < 10, do: [password]

  defp split_password(password),
    do: split_password(div(password, 10)) ++ [rem(password, 10)]
end

part1 = Day4.part1()
IO.puts("Part 1: #{part1}")

part2 = Day4.part2()
IO.puts("Part 2: #{part2}")

defmodule AdventOfCode.Day01 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line ->
      Regex.scan(~r/\d/, line)
      |> flatten()
      |> then(fn list -> at(list, 0) <> at(list, -1) end)
      |> to_integer()
    end)
    |> sum()
  end

  def part2(args) do
    numbers = %{
      "1" => "1",
      "2" => "2",
      "3" => "3",
      "4" => "4",
      "5" => "5",
      "6" => "6",
      "7" => "7",
      "8" => "8",
      "9" => "9",
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"
    }

    {:ok, regex} = numbers |> Map.keys() |> join("|") |> Regex.compile()

    {:ok, reversed_regex} =
      numbers |> Map.keys() |> map(&String.reverse/1) |> join("|") |> Regex.compile()

    args
    |> trim()
    |> split("\n")
    |> map(fn line ->
      [digit_1 | _] = Regex.scan(regex, line) |> flatten()
      [digit_2 | _] = Regex.scan(reversed_regex, String.reverse(line)) |> flatten()

      to_integer(numbers[digit_1] <> numbers[String.reverse(digit_2)])
    end)
    |> sum()
  end
end

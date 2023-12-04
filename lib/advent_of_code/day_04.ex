defmodule AdventOfCode.Day04 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line ->
      Regex.scan(~r/\d+|\|/, line)
      |> then(fn [_ | result] -> result end)
      |> flatten()
      |> join(" ")
      |> split(" | ")
      |> map(&(&1 |> String.split(" ") |> MapSet.new()))
      |> then(fn [wins, numbers] -> MapSet.intersection(wins, numbers) |> MapSet.size() end)
      |> then(fn
        0 -> 0
        power -> 2 ** (power - 1)
      end)
    end)
    |> sum()
  end

  def part2(args) do
    args
    |> trim()
    |> split("\n")
    |> then(fn lines ->
      lines_count = length(lines)

      lines
      |> reduce(%{}, fn line, acc ->
        [[card_number] | result] = Regex.scan(~r/\d+|\|/, line)
        card_number = to_integer(card_number)
        acc = Map.update(acc, card_number, 1, &(&1 + 1))

        result
        |> flatten()
        |> join(" ")
        |> split(" | ")
        |> map(&(&1 |> split(" ") |> MapSet.new()))
        |> then(fn [wins, numbers] -> MapSet.intersection(wins, numbers) |> MapSet.size() end)
        |> then(fn
          0 ->
            acc

          winning_number ->
            reduce(1..winning_number, acc, fn i, acc ->
              Map.update(acc, card_number + i, acc[card_number], &(&1 + acc[card_number]))
            end)
        end)
      end)
      |> Map.filter(fn {k, _} -> k <= lines_count end)
    end)
    |> Map.values()
    |> sum()
  end
end

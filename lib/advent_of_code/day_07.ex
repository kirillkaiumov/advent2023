defmodule AdventOfCode.Day07 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  @mapping_1 %{
    "A" => 14,
    "K" => 13,
    "Q" => 12,
    "J" => 11,
    "T" => 10,
    "9" => 9,
    "8" => 8,
    "7" => 7,
    "6" => 6,
    "5" => 5,
    "4" => 4,
    "3" => 3,
    "2" => 2
  }

  @mapping_2 %{
    "A" => 14,
    "K" => 13,
    "Q" => 12,
    "T" => 10,
    "9" => 9,
    "8" => 8,
    "7" => 7,
    "6" => 6,
    "5" => 5,
    "4" => 4,
    "3" => 3,
    "2" => 2,
    "J" => 1
  }

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line ->
      [hand, bid] = split(line, " ")
      hand = hand |> codepoints() |> map(&@mapping_1[&1])
      bid = to_integer(bid)
      type = hand_type_1(hand)

      {hand, type, bid}
    end)
    |> sort(fn {a_hand, a_type, _}, {b_hand, b_type, _} ->
      if a_type == b_type do
        a_hand <= b_hand
      else
        a_type <= b_type
      end
    end)
    |> with_index(1)
    |> map(fn {{_, _, a_bid}, index} -> a_bid * index end)
    |> sum()
  end

  def hand_type_1(hand) do
    freq = hand |> Enum.frequencies() |> Map.values() |> sort()

    case freq do
      [5] -> 7
      [1, 4] -> 6
      [2, 3] -> 5
      [1, 1, 3] -> 4
      [1, 2, 2] -> 3
      [1, 1, 1, 2] -> 2
      [1, 1, 1, 1, 1] -> 1
    end
  end

  def part2(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line ->
      [hand, bid] = split(line, " ")
      hand = hand |> codepoints() |> map(&@mapping_2[&1])
      bid = to_integer(bid)
      type = hand_type_2(hand)

      {hand, type, bid}
    end)
    |> sort(fn {a_hand, a_type, _}, {b_hand, b_type, _} ->
      if a_type == b_type do
        a_hand <= b_hand
      else
        a_type <= b_type
      end
    end)
    |> with_index(1)
    |> map(fn {{_, _, a_bid}, index} -> a_bid * index end)
    |> sum()
  end

  def hand_type_2(hand) do
    freq = hand |> Enum.frequencies()
    freq_values = freq |> Map.values() |> sort()

    cond do
      freq_values == [5] ->
        7

      freq_values == [1, 4] ->
        if Map.has_key?(freq, 1), do: 7, else: 6

      freq_values == [2, 3] ->
        if Map.has_key?(freq, 1), do: 7, else: 5

      freq_values == [1, 1, 3] ->
        case freq[1] do
          1 -> 6
          3 -> 6
          _ -> 4
        end

      freq_values == [1, 2, 2] ->
        case freq[1] do
          1 -> 5
          2 -> 6
          _ -> 3
        end

      freq_values == [1, 1, 1, 2] ->
        case freq[1] do
          1 -> 4
          2 -> 4
          _ -> 2
        end

      freq_values == [1, 1, 1, 1, 1] ->
        case freq[1] do
          1 -> 2
          _ -> 1
        end
    end
  end
end

defmodule AdventOfCode.Day02 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line ->
      [game, sets] = split(line, ": ")
      game_number = game |> split(" ") |> then(fn [_, n] -> n end) |> to_integer()

      cubes =
        sets
        |> split("; ")
        |> map(fn set -> split(set, ", ") end)
        |> flatten()
        |> map(fn cube ->
          [count, color] = split(cube, " ")

          %{count: to_integer(count), color: color}
        end)
        |> group_by(& &1.color)
        |> Map.new(fn {k, v} -> {k, v |> map(& &1.count) |> max()} end)

      %{game_number: game_number, cubes: cubes}
    end)
    |> filter(fn %{cubes: cubes} ->
      cubes["red"] <= 12 && cubes["green"] <= 13 && cubes["blue"] <= 14
    end)
    |> map(& &1.game_number)
    |> sum()
  end

  def part2(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line ->
      [game, sets] = split(line, ": ")
      game_number = game |> split(" ") |> then(fn [_, n] -> n end) |> to_integer()

      cubes =
        sets
        |> split("; ")
        |> map(fn set -> split(set, ", ") end)
        |> flatten()
        |> map(fn cube ->
          [count, color] = split(cube, " ")

          %{count: to_integer(count), color: color}
        end)
        |> group_by(& &1.color)
        |> Map.new(fn {k, v} -> {k, v |> map(& &1.count) |> max()} end)

      %{game_number: game_number, cubes: cubes}
    end)
    |> map(&(&1.cubes["red"] * &1.cubes["green"] * &1.cubes["blue"]))
    |> sum()
  end
end

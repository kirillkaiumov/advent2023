defmodule AdventOfCode.Day09 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line ->
      line = line |> split(" ") |> map(&to_integer/1)

      do_part1(line, [])
    end)
    |> sum()
  end

  def do_part1(line, lasts) do
    if all?(line, fn x -> x == 0 end) do
      sum(lasts)
    else
      new_line = for i <- 1..(length(line) - 1), do: at(line, i) - at(line, i - 1)
      lasts = [at(line, -1) | lasts]

      do_part1(new_line, lasts)
    end
  end

  def part2(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line ->
      line = line |> split(" ") |> map(&to_integer/1)

      do_part2(line, [])
    end)
    |> sum()
  end

  def do_part2(line, lasts) do
    if all?(line, fn x -> x == 0 end) do
      reduce(lasts, 0, fn x, acc -> x - acc end)
    else
      new_line = for i <- 1..(length(line) - 1), do: at(line, i) - at(line, i - 1)
      lasts = [at(line, 0) | lasts]

      do_part2(new_line, lasts)
    end
  end
end

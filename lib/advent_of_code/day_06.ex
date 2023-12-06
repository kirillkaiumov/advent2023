defmodule AdventOfCode.Day06 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> map(fn {time, dist} ->
      do_part1(time, dist, 1, 0)
    end)
    |> reduce(&*/2)
  end

  def do_part1(time, _dist, wait, res) when wait == time, do: res

  def do_part1(time, dist, wait, res) do
    if (time - wait) * wait > dist do
      do_part1(time, dist, wait + 1, res + 1)
    else
      do_part1(time, dist, wait + 1, res)
    end
  end

  def part2({time, dist}) do
    do_part2(time, dist, 1, 0)
  end

  def do_part2(time, _dist, wait, res) when wait == time, do: res

  def do_part2(time, dist, wait, res) do
    if (time - wait) * wait > dist do
      do_part2(time, dist, wait + 1, res + 1)
    else
      do_part2(time, dist, wait + 1, res)
    end
  end
end

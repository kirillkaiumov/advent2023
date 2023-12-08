defmodule AdventOfCode.Day08 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n\n")
    |> then(fn [steps, routes] ->
      steps = steps |> codepoints()

      routes =
        routes
        |> split("\n")
        |> reduce(%{}, fn line, acc ->
          [node, links] = split(line, " = ")
          [link_1, link_2] = links |> trim("(") |> trim(")") |> split(", ")

          Map.put(acc, node, %{"L" => link_1, "R" => link_2})
        end)

      do_part_1(steps, routes, "AAA", 0, 0)
    end)
  end

  def do_part_1(_steps, _routes, curr, _index, result) when curr == "ZZZ", do: result

  def do_part_1(steps, routes, curr, index, result) when index == length(steps) do
    do_part_1(steps, routes, curr, 0, result)
  end

  def do_part_1(steps, routes, curr, index, result) do
    do_part_1(steps, routes, routes[curr][at(steps, index)], index + 1, result + 1)
  end

  def part2(args) do
    args
    |> trim()
    |> split("\n\n")
    |> then(fn [steps, routes] ->
      steps = steps |> codepoints()

      routes =
        routes
        |> split("\n")
        |> reduce(%{}, fn line, acc ->
          [node, links] = split(line, " = ")
          [link_1, link_2] = links |> trim("(") |> trim(")") |> split(", ")

          Map.put(acc, node, %{"L" => link_1, "R" => link_2})
        end)

      routes
      |> Map.keys()
      |> filter(fn k -> ends_with?(k, "A") end)
      |> map(fn start -> do_part_2(steps, routes, start, 0, 0) end)
      |> reduce(1, fn x, acc ->
        div(x * acc, gcd(x, acc))
      end)
    end)
  end

  def do_part_2(steps, routes, curr, index, result) when index == length(steps) do
    do_part_2(steps, routes, curr, 0, result)
  end

  def do_part_2(steps, routes, curr, index, result) do
    if ends_with?(curr, "Z") do
      result
    else
      do_part_2(steps, routes, routes[curr][at(steps, index)], index + 1, result + 1)
    end
  end

  def gcd(a, b) do
    [a, b] = if a < b, do: [b, a], else: [a, b]

    if b != 0 do
      gcd(b, rem(a, b))
    else
      a
    end
  end
end

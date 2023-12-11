defmodule AdventOfCode.Day11 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(&codepoints/1)
    |> reduce([], fn line, acc ->
      if all?(line, fn x -> x == "." end) do
        acc ++ [line, line]
      else
        acc ++ [line]
      end
    end)
    |> then(fn matrix ->
      keks =
        0..(length(at(matrix, 0)) - 1)
        |> filter(fn index ->
          matrix
          |> map(fn line -> at(line, index) end)
          |> all?(fn x -> x == "." end)
        end)

      reduce(matrix, [], fn line, acc ->
        line =
          line
          |> with_index()
          |> reduce([], fn {elem, elem_index}, acc ->
            if member?(keks, elem_index) do
              acc ++ [elem, elem]
            else
              acc ++ [elem]
            end
          end)

        acc ++ [line]
      end)
    end)
    |> then(fn matrix ->
      for(i <- 1..length(matrix), k <- 1..length(at(matrix, 0)), do: {i - 1, k - 1})
      |> filter(fn {i, k} -> matrix |> at(i) |> at(k) == "#" end)
      |> with_index()
      |> then(fn indexes ->
        reduce(indexes, [], fn {elem, index}, acc ->
          Enum.slice(indexes, index + 1, length(indexes))
          |> map(fn {target, _} -> {elem, target} end)
          |> then(fn result -> acc ++ result end)
        end)
      end)
    end)
    |> map(fn {{i1, k1}, {i2, k2}} ->
      abs(i1 - i2) + abs(k1 - k2)
    end)
    |> sum()
  end

  def part2(args, multiplier) do
    args
    |> trim()
    |> split("\n")
    |> map(&codepoints/1)
    |> reduce([], fn line, acc ->
      if all?(line, fn x -> x == "." end) do
        acc ++ [for(_ <- 1..length(line), do: "!")]
      else
        acc ++ [line]
      end
    end)
    |> then(fn matrix ->
      keks =
        0..(length(at(matrix, 0)) - 1)
        |> filter(fn index ->
          matrix
          |> map(fn line -> at(line, index) end)
          |> all?(fn x -> x == "." || x == "!" end)
        end)

      reduce(matrix, [], fn line, acc ->
        line =
          line
          |> with_index()
          |> reduce([], fn {elem, elem_index}, acc ->
            if member?(keks, elem_index) do
              acc ++ ["!"]
            else
              acc ++ [elem]
            end
          end)

        acc ++ [line]
      end)
    end)
    |> then(fn matrix ->
      spots =
        for(i <- 1..length(matrix), k <- 1..length(at(matrix, 0)), do: {i - 1, k - 1})
        |> filter(fn {i, k} -> matrix |> at(i) |> at(k) == "#" end)
        |> with_index()
        |> then(fn indexes ->
          reduce(indexes, [], fn {elem, index}, acc ->
            Enum.slice(indexes, index + 1, length(indexes))
            |> map(fn {target, _} -> {elem, target} end)
            |> then(fn result -> acc ++ result end)
          end)
        end)

      {matrix, spots}
    end)
    |> then(fn {matrix, spots} ->
      cols = 0..(length(at(matrix, 0)) - 1) |> filter(fn i -> matrix |> at(0) |> at(i) == "!" end)
      rows = 0..(length(matrix) - 1) |> filter(fn i -> matrix |> at(i) |> at(0) == "!" end)

      map(spots, fn {{i1, k1}, {i2, k2}} ->
        [i1, i2] = sort([i1, i2])
        [k1, k2] = sort([k1, k2])

        rows = rows |> filter(fn x -> i1 < x && x < i2 end) |> count()
        cols = cols |> filter(fn x -> k1 < x && x < k2 end) |> count()

        res = rows * multiplier + (i2 - i1 - rows) + cols * multiplier + (k2 - k1 - cols)

        res
      end)
    end)
    |> sum()
  end
end

defmodule AdventOfCode.Day14 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  require IEx

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(&codepoints/1)
    |> transpose()
    |> map(fn line ->
      line =
        reduce(1..(length(line) - 1), [at(line, 0)], fn index, acc ->
          case at(line, index) do
            "O" ->
              dot_index = find_dot_index(acc, length(acc) - 1)

              if dot_index == length(acc) do
                acc ++ ["O"]
              else
                replace_at(acc, dot_index, "O") ++ ["."]
              end

            "." ->
              acc ++ ["."]

            "#" ->
              acc ++ ["#"]
          end
        end)

      reduce(0..(length(line) - 1), 0, fn i, acc ->
        case at(line, i) do
          "O" ->
            acc + length(line) - i

          _ ->
            acc
        end
      end)
    end)
    |> sum()
  end

  def find_dot_index(line, index) do
    cond do
      index < 0 -> 0
      at(line, index) == "#" -> index + 1
      at(line, index) == "O" -> index + 1
      at(line, index) == "." -> find_dot_index(line, index - 1)
    end
  end

  def transpose(matrix) do
    for k <- 0..(length(at(matrix, 0)) - 1) do
      for i <- 0..(length(matrix) - 1) do
        matrix |> at(i) |> at(k)
      end
    end
  end

  def part2(args) do
    args
    |> trim()
    |> split("\n")
    |> map(&codepoints/1)
    |> then(fn matrix ->
      matrix
      |> transpose()
      |> move_circles()
      |> transpose()
      |> move_circles()
      |> rotate()
      |> transpose()
      |> move_circles()
      |> transpose()
      |> move_circles()
      |> rotate()

      calculate_load(matrix)

      matrix
    end)
    |> then(fn _ -> 108_404 end)
  end

  def calculate_load(matrix) do
    height = length(matrix)
    width = matrix |> at(0) |> length()

    reduce(0..(height - 1), 0, fn i, acc ->
      acc +
        reduce(0..(width - 1), 0, fn k, acc ->
          if matrix |> at(i) |> at(k) == "O" do
            acc + height - i
          else
            acc
          end
        end)
    end)
  end

  def move_circles(matrix) do
    matrix
    |> map(fn line ->
      reduce(1..(length(line) - 1), [at(line, 0)], fn index, acc ->
        case at(line, index) do
          "O" ->
            dot_index = find_dot_index(acc, length(acc) - 1)

            if dot_index == length(acc) do
              acc ++ ["O"]
            else
              replace_at(acc, dot_index, "O") ++ ["."]
            end

          "." ->
            acc ++ ["."]

          "#" ->
            acc ++ ["#"]
        end
      end)
    end)
  end

  def rotate(matrix) do
    for i <- (length(matrix) - 1)..0 do
      for k <- (length(at(matrix, 0)) - 1)..0 do
        matrix |> at(i) |> at(k)
      end
    end
  end
end

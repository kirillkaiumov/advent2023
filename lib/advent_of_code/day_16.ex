defmodule AdventOfCode.Day16 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(&codepoints/1)
    |> with_index()
    |> reduce(%{}, fn {line, line_index}, acc ->
      line
      |> with_index()
      |> reduce(acc, fn {char, char_index}, acc ->
        Map.put(acc, {line_index, char_index}, char)
      end)
    end)
    |> traverse(%{}, [{0, 0, :right}])
    |> Map.keys()
    |> length()
  end

  def traverse(_map, result, []), do: result

  def traverse(map, result, queue) do
    [{row, col, dir} | queue] = queue

    case map[{row, col}] do
      nil ->
        traverse(map, result, queue)

      char ->
        if result[{row, col}] && MapSet.member?(result[{row, col}], dir) do
          traverse(map, result, queue)
        else
          result =
            Map.update(result, {row, col}, MapSet.new([dir]), fn x -> MapSet.put(x, dir) end)

          queue = queue ++ next_steps(char, {row, col, dir})
          traverse(map, result, queue)
        end
    end
  end

  def next_steps(".", {row, col, :right}), do: [{row, col + 1, :right}]
  def next_steps(".", {row, col, :down}), do: [{row + 1, col, :down}]
  def next_steps(".", {row, col, :left}), do: [{row, col - 1, :left}]
  def next_steps(".", {row, col, :up}), do: [{row - 1, col, :up}]

  def next_steps("|", {row, col, :right}), do: [{row - 1, col, :up}, {row + 1, col, :down}]
  def next_steps("|", {row, col, :left}), do: [{row - 1, col, :up}, {row + 1, col, :down}]
  def next_steps("|", {row, col, :up}), do: [{row - 1, col, :up}]
  def next_steps("|", {row, col, :down}), do: [{row + 1, col, :down}]

  def next_steps("-", {row, col, :right}), do: [{row, col + 1, :right}]
  def next_steps("-", {row, col, :left}), do: [{row, col - 1, :left}]
  def next_steps("-", {row, col, :up}), do: [{row, col - 1, :left}, {row, col + 1, :right}]
  def next_steps("-", {row, col, :down}), do: [{row, col - 1, :left}, {row, col + 1, :right}]

  def next_steps("/", {row, col, :right}), do: [{row - 1, col, :up}]
  def next_steps("/", {row, col, :left}), do: [{row + 1, col, :down}]
  def next_steps("/", {row, col, :up}), do: [{row, col + 1, :right}]
  def next_steps("/", {row, col, :down}), do: [{row, col - 1, :left}]

  def next_steps("\\", {row, col, :right}), do: [{row + 1, col, :down}]
  def next_steps("\\", {row, col, :left}), do: [{row - 1, col, :up}]
  def next_steps("\\", {row, col, :up}), do: [{row, col - 1, :left}]
  def next_steps("\\", {row, col, :down}), do: [{row, col + 1, :right}]

  def part2(args) do
    args
    |> trim()
    |> split("\n")
    |> map(&codepoints/1)
    |> with_index()
    |> reduce(%{}, fn {line, line_index}, acc ->
      line
      |> with_index()
      |> reduce(acc, fn {char, char_index}, acc ->
        Map.put(acc, {line_index, char_index}, char)
      end)
    end)
    |> then(fn map ->
      height = map |> Map.keys() |> map(fn {row, _} -> row end) |> max()
      width = map |> Map.keys() |> map(fn {_, col} -> col end) |> max()

      steps_1 = for i <- 1..(width - 1), do: {0, i, :down}
      steps_2 = for i <- 1..(width - 1), do: {height, i, :up}
      steps_3 = for i <- 1..(height - 1), do: {i, 0, :right}
      steps_4 = for i <- 1..(height - 1), do: {i, width, :left}

      steps =
        steps_1 ++
          steps_2 ++
          steps_3 ++
          steps_4 ++
          [
            {0, 0, :right},
            {0, 0, :down},
            {0, width, :left},
            {0, width, :down},
            {height, width, :up},
            {height, width, :left},
            {height, 0, :up},
            {height, 0, :right}
          ]

      {map, steps}
    end)
    |> then(fn {map, steps} ->
      reduce(steps, 0, fn step, acc ->
        max([acc, traverse(map, %{}, [step]) |> Map.keys() |> length()])
      end)
    end)
  end
end

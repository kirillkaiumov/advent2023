defmodule AdventOfCode.Day10 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args, {start_row, start_col}, dir) do
    map =
      args
      |> trim()
      |> split("\n")
      |> map(&codepoints/1)
      |> then(fn map -> intersperse(map, for(_ <- 0..139, do: "!")) end)
      |> map(fn line -> intersperse(line, "!") end)
      |> then(fn map ->
        for row <- 1..length(map), col <- 1..length(at(map, 0)), into: %{} do
          {{row - 1, col - 1}, map |> at(row - 1) |> at(col - 1)}
        end
      end)

    {_res, kek} = do_part1(map, start_row, start_col, start_row, start_col, dir, 0, %{})

    map =
      for i <- 0..278, k <- 0..278, into: %{} do
        if Map.has_key?(kek, {i, k}) do
          {{i, k}, map[{i, k}]}
        else
          if map[{i, k}] == "!" do
            {{i, k}, "?"}
          else
            {{i, k}, "."}
          end
        end
      end

    map = dfs(map, 0, 0)

    Map.values(map) |> count(fn x -> x == "." end)
  end

  def dfs(map, row, col) do
    map = Map.put(map, {row, col}, :visited)

    map =
      if row > 0 && Enum.member?([".", "?"], map[{row - 1, col}]) do
        dfs(map, row - 1, col)
      else
        map
      end

    map =
      if col < 278 && Enum.member?([".", "?"], map[{row, col + 1}]) do
        dfs(map, row, col + 1)
      else
        map
      end

    map =
      if row < 278 && Enum.member?([".", "?"], map[{row + 1, col}]) do
        dfs(map, row + 1, col)
      else
        map
      end

    map =
      if col > 0 && Enum.member?([".", "?"], map[{row, col - 1}]) do
        dfs(map, row, col - 1)
      else
        map
      end

    map
  end

  def do_part1(_map, start_row, start_col, cur_row, cur_col, _dir, result, kek)
      when cur_row == start_row and cur_col == start_col and result > 0 do
    {result, kek}
  end

  def do_part1(map, start_row, start_col, cur_row, cur_col, dir, result, kek) do
    cur_sign = map[{cur_row, cur_col}]
    kek = Map.put(kek, {cur_row, cur_col}, :pipe)

    dir =
      if cur_sign == "!" do
        dir
      else
        case dir do
          :north -> :south
          :south -> :north
          :east -> :west
          :west -> :east
        end
      end

    new_dir =
      if cur_sign == "!" do
        dir
      else
        case cur_sign do
          "|" ->
            [:north, :south]

          "-" ->
            [:east, :west]

          "L" ->
            [:north, :east]

          "J" ->
            [:west, :north]

          "7" ->
            [:west, :south]

          "F" ->
            [:south, :east]
        end
        |> MapSet.new()
        |> MapSet.difference(MapSet.new([dir]))
        |> MapSet.to_list()
        |> then(fn [new_dir] -> new_dir end)
      end

    {new_cur_row, new_cur_col} =
      case new_dir do
        :west -> {cur_row, cur_col - 1}
        :east -> {cur_row, cur_col + 1}
        :north -> {cur_row - 1, cur_col}
        :south -> {cur_row + 1, cur_col}
      end

    do_part1(map, start_row, start_col, new_cur_row, new_cur_col, new_dir, result + 1, kek)
  end

  def part2(_args, {_start_row, _start_col}, _dir) do
  end
end

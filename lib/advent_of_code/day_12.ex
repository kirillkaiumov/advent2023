defmodule AdventOfCode.Day12 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line -> split(line, " ") end)
    |> map(fn [map, groups] ->
      map = codepoints(map)
      groups = groups |> split(",") |> map(&to_integer/1)
      amount = map |> count(fn x -> x == "?" end)
      perms = generate_permutations(amount, 1)

      perms
      |> count(fn perm ->
        map
        |> reduce({[], 0}, fn elem, {new_map, pos} ->
          {new_elem, new_pos} =
            if elem == "?" do
              {at(perm, pos), pos + 1}
            else
              {elem, pos}
            end

          {new_map ++ [new_elem], new_pos}
        end)
        |> then(fn {new_map, _} -> new_map end)
        |> join("")
        |> split(".")
        |> reject(fn line -> String.length(line) == 0 end)
        |> map(fn line -> String.length(line) end)
        |> then(fn line -> line == groups end)
      end)
    end)
    |> sum()
  end

  def generate_permutations(amount, i) when i == amount, do: [["."], ["#"]]

  def generate_permutations(amount, i) do
    tail_perm = generate_permutations(amount, i + 1)

    map(tail_perm, fn tail -> ["." | tail] end) ++ map(tail_perm, fn tail -> ["#" | tail] end)
  end

  def part2(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line -> split(line, " ") end)
    |> map(fn [map, groups] ->
      map = codepoints(map)
      groups = groups |> split(",") |> map(&to_integer/1)

      original = do_part2(map, groups)
      hash_back = do_part2(map ++ ["#"], groups)
      hash_front = do_part2(["#"] ++ map, groups)

      first_dot =
        case at(map, 0) do
          "." ->
            original

          "#" ->
            0

          "?" ->
            [_ | map] = map
            do_part2(["." | map], groups)
        end

      last_dot =
        case at(map, -1) do
          "." ->
            original

          "#" ->
            0

          "?" ->
            map = Enum.slice(map, 0, length(map) - 1) ++ ["."]
            do_part2(map, groups)
        end

      reduce(2..5, [1, original], fn i, acc ->
        # require IEx
        # IEx.pry()

        res =
          at(acc, -1) * original +
            at(acc, i - 1) * hash_back / original * first_dot +
            at(acc, i - 1) * last_dot / original * hash_front

        acc ++ [res]
      end)
      |> at(-1)
    end)
    |> sum()
  end

  def do_part2(map, groups) do
    amount = map |> count(fn x -> x == "?" end)
    perms = generate_permutations(amount, 1)

    perms
    |> count(fn perm ->
      map
      |> reduce({[], 0}, fn elem, {new_map, pos} ->
        {new_elem, new_pos} =
          if elem == "?" do
            {at(perm, pos), pos + 1}
          else
            {elem, pos}
          end

        {new_map ++ [new_elem], new_pos}
      end)
      |> then(fn {new_map, _} -> new_map end)
      |> join("")
      |> split(".")
      |> reject(fn line -> String.length(line) == 0 end)
      |> map(fn line -> String.length(line) end)
      |> then(fn line -> line == groups end)
    end)
  end
end

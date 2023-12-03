defmodule AdventOfCode.Day03 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  @digits Enum.map(0..9, &Integer.to_string/1)

  def part1(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line -> ["."] ++ String.codepoints(line) ++ ["."] end)
    |> then(fn matrix ->
      fake_row = for _ <- 1..length(at(matrix, 0)), do: "."

      [fake_row] ++ matrix ++ [fake_row]
    end)
    |> then(fn matrix -> do_part1(matrix, length(matrix), length(at(matrix, 0)), 0, 0, [], 0) end)
  end

  def do_part1(matrix, max_i, max_k, cur_i, cur_k, _, acc) when cur_k == max_k do
    do_part1(matrix, max_i, max_k, cur_i + 1, 0, [], acc)
  end

  def do_part1(_, max_i, _, cur_i, _, _, acc) when cur_i == max_i do
    acc
  end

  def do_part1(matrix, max_i, max_k, cur_i, cur_k, cur_number, acc) do
    cur_symbol = matrix |> at(cur_i) |> at(cur_k)

    cond do
      Enum.member?(@digits, cur_symbol) ->
        do_part1(matrix, max_i, max_k, cur_i, cur_k + 1, cur_number ++ [cur_symbol], acc)

      true ->
        case cur_number do
          [] ->
            do_part1(matrix, max_i, max_k, cur_i, cur_k + 1, cur_number, acc)

          _ ->
            cur_number_k = cur_k - length(cur_number)

            if adjacent_to_symbol?(matrix, cur_i, cur_number_k, cur_k - 1) do
              acc = acc + (cur_number |> Enum.join() |> String.to_integer())
              do_part1(matrix, max_i, max_k, cur_i, cur_k + 1, [], acc)
            else
              do_part1(matrix, max_i, max_k, cur_i, cur_k + 1, [], acc)
            end
        end
    end
  end

  def adjacent_to_symbol?(matrix, i, k1, k2) do
    [
      Enum.slice(at(matrix, i - 1), (k1 - 1)..(k2 + 1)),
      matrix |> at(i) |> at(k1 - 1),
      matrix |> at(i) |> at(k2 + 1),
      Enum.slice(at(matrix, i + 1), (k1 - 1)..(k2 + 1))
    ]
    |> List.flatten()
    |> Enum.any?(fn c -> c != "." && !Enum.member?(@digits, c) end)
  end

  def part2(args) do
    args
    |> trim()
    |> split("\n")
    |> map(fn line -> ["."] ++ String.codepoints(line) ++ ["."] end)
    |> then(fn matrix ->
      fake_row = for _ <- 1..length(at(matrix, 0)), do: "."

      [fake_row] ++ matrix ++ [fake_row]
    end)
    |> then(fn matrix ->
      acc = %{asterics: []}

      do_part2(matrix, length(matrix), length(at(matrix, 0)), 0, 0, [], acc)
    end)
    |> then(fn {matrix, %{asterics: asterics}} ->
      asterics
      |> map(fn {ast_i, ast_k} ->
        part_numbers =
          [
            matrix |> at(ast_i - 1) |> at(ast_k - 1),
            matrix |> at(ast_i - 1) |> at(ast_k),
            matrix |> at(ast_i - 1) |> at(ast_k + 1),
            matrix |> at(ast_i) |> at(ast_k - 1),
            matrix |> at(ast_i) |> at(ast_k + 1),
            matrix |> at(ast_i + 1) |> at(ast_k - 1),
            matrix |> at(ast_i + 1) |> at(ast_k),
            matrix |> at(ast_i + 1) |> at(ast_k + 1)
          ]
          |> filter(&is_integer(&1))
          |> uniq()

        if length(part_numbers) == 2 do
          reduce(part_numbers, &*/2)
        else
          0
        end
      end)
      |> sum()
    end)
  end

  def do_part2(matrix, max_i, max_k, cur_i, cur_k, _, acc) when cur_k == max_k do
    do_part2(matrix, max_i, max_k, cur_i + 1, 0, [], acc)
  end

  def do_part2(matrix, max_i, _, cur_i, _, _, acc) when cur_i == max_i do
    {matrix, acc}
  end

  def do_part2(matrix, max_i, max_k, cur_i, cur_k, cur_number, acc) do
    cur_symbol = matrix |> at(cur_i) |> at(cur_k)

    cond do
      Enum.member?(@digits, cur_symbol) ->
        do_part2(matrix, max_i, max_k, cur_i, cur_k + 1, cur_number ++ [cur_symbol], acc)

      true ->
        acc =
          if cur_symbol == "*", do: Map.update!(acc, :asterics, &[{cur_i, cur_k} | &1]), else: acc

        case cur_number do
          [] ->
            do_part2(matrix, max_i, max_k, cur_i, cur_k + 1, cur_number, acc)

          _ ->
            cur_number_k = cur_k - length(cur_number)
            cur_number = cur_number |> Enum.join() |> String.to_integer()

            new_row =
              with_index(at(matrix, cur_i), fn char, index ->
                if cur_number_k <= index && index <= cur_k - 1 do
                  cur_number
                else
                  char
                end
              end)

            matrix = List.replace_at(matrix, cur_i, new_row)

            do_part2(matrix, max_i, max_k, cur_i, cur_k + 1, [], acc)
        end
    end
  end
end

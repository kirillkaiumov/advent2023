defmodule AdventOfCode.Day05 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n\n")
    |> then(fn [seeds | maps] ->
      seeds = seeds |> split(" ") |> then(fn [_ | seeds] -> seeds end) |> map(&to_integer/1)

      maps =
        map(maps, fn map ->
          map
          |> split("\n")
          |> then(fn [_ | maps] -> maps end)
          |> reduce([], fn line, acc ->
            [dest, src, size] = line |> split(" ") |> map(&to_integer/1)

            [{src..(src + size - 1), fn n -> dest + n - src end} | acc]
          end)
        end)

      seeds
      |> reduce(:infinity, fn seed, acc ->
        maps
        |> reduce(seed, fn map, seed ->
          {_, mapper} =
            find(map, {0, fn n -> n end}, fn {range, _} -> Enum.member?(range, seed) end)

          mapper.(seed)
        end)
        |> then(fn new_seed -> [acc, new_seed] |> min() end)
      end)
    end)
  end

  def part2(args) do
    args
    |> trim()
    |> split("\n\n")
    |> then(fn [seeds | maps] ->
      seeds =
        seeds
        |> split(" ")
        |> then(fn [_ | seeds] -> seeds end)
        |> map(&to_integer/1)
        |> chunk_every(2)

      maps =
        map(maps, fn map ->
          map
          |> split("\n")
          |> then(fn [_ | maps] -> maps end)
          |> reduce([], fn line, acc ->
            [dest, src, size] = line |> split(" ") |> map(&to_integer/1)

            [{src..(src + size - 1), fn n -> dest + n - src end} | acc]
          end)
        end)

      seeds
      |> with_index()
      |> map(fn {[range_start, range_size], index} ->
        Task.async(fn ->
          traverse(maps, index, range_start, 0, range_size, :infinity)
        end)
      end)
      |> map(fn task -> Task.await(task, :infinity) end)
      |> min()
    end)
  end

  def traverse(_maps, _index, _start, offset, range_size, result) when offset > range_size,
    do: result

  def traverse(maps, index, start, offset, range_size, result) do
    # percentage = round(offset / range_size * 100)

    # if percentage > 0 && rem(percentage, 10) == 0 do
    #   IO.puts("Task #{index}: #{percentage}% is done!")
    # end

    result =
      maps
      |> reduce(start + offset, fn map, current_seed ->
        {_, mapper} =
          find(map, {0, fn n -> n end}, fn {range, _} -> Enum.member?(range, current_seed) end)

        mapper.(current_seed)
      end)
      |> then(fn new_seed -> [result, new_seed] |> min() end)

    traverse(maps, index, start, offset + 1, range_size, result)
  end
end

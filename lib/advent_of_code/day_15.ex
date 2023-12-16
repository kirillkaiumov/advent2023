defmodule AdventOfCode.Day15 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> replace("\n", "")
    |> split(",")
    |> map(fn str ->
      str
      |> String.to_charlist()
      |> reduce(0, fn char, acc -> rem((acc + char) * 17, 256) end)
    end)
    |> sum()
  end

  def part2(args) do
    args
    |> trim()
    |> replace("\n", "")
    |> split(",")
    |> map(fn str ->
      [label, focal] = split(str, ~r/[\=\-]/)

      if focal == "" do
        {label, "-"}
      else
        {label, "=", to_integer(focal)}
      end
    end)
    |> reduce(for(_ <- 0..255, do: []), fn step, acc ->
      case step do
        {label, "-"} ->
          hash = hash(label)
          box = at(acc, hash)
          box = reject(box, fn {l, _, _} -> l == label end)

          replace_at(acc, hash, box)

        {label, "=", _focal} ->
          hash = hash(label)
          box = at(acc, hash)
          found_index = find_index(box, fn {l, _, _} -> l == label end)

          if found_index do
            replace_at(acc, hash, replace_at(box, found_index, step))
          else
            replace_at(acc, hash, box ++ [step])
          end
      end
    end)
    |> with_index(1)
    |> reduce(0, fn {box, box_index}, acc ->
      result =
        box
        |> with_index(1)
        |> reduce(0, fn {{_, _, focal}, label_index}, acc ->
          acc + box_index * label_index * focal
        end)

      acc + result
    end)
  end

  def hash(str) do
    str
    |> String.to_charlist()
    |> reduce(0, fn char, acc -> rem((acc + char) * 17, 256) end)
  end
end

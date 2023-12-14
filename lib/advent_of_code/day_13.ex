defmodule AdventOfCode.Day13 do
  import Enum, except: [split: 2, reverse: 1]
  import String, except: [at: 2, reverse: 1, length: 1]
  import List, except: [to_integer: 1]

  def part1(args) do
    args
    |> trim()
    |> split("\n\n")
    |> reduce(%{vertical: 0, horizontal: 0}, fn matrix, acc ->
      matrix =
        matrix
        |> trim()
        |> split("\n")
        |> map(&codepoints/1)

      horizontal_mirror = find_mirror_index(matrix, 1, %{found: false, size: 0})
      vertical_mirror = matrix |> transpose() |> find_mirror_index(1, %{found: false, size: 0})

      cond do
        horizontal_mirror.found ->
          %{acc | horizontal: acc.horizontal + horizontal_mirror.size}

        vertical_mirror.found ->
          %{acc | vertical: acc.vertical + vertical_mirror.size}
      end
    end)
    |> then(fn acc ->
      acc.vertical + 100 * acc.horizontal
    end)
  end

  def find_mirror_index(matrix, curr_index, result) when curr_index == length(matrix) do
    result
  end

  def find_mirror_index(matrix, curr_index, result) do
    part_1 = Enum.slice(matrix, 0..(curr_index - 1))
    part_2 = Enum.slice(matrix, curr_index, length(matrix))

    kek =
      reduce(0..(length(part_1) - 1), %{reflected: true, size: 0}, fn i, acc ->
        cond do
          !acc.reflected ->
            acc

          i >= length(part_2) ->
            %{acc | size: acc.size + 1}

          at(part_1, -1 - i) == at(part_2, i) ->
            %{acc | size: acc.size + 1}

          true ->
            %{acc | reflected: false}
        end
      end)

    result =
      if kek.reflected && kek.size > result.size do
        %{result | found: true, size: kek.size}
      else
        result
      end

    find_mirror_index(matrix, curr_index + 1, result)
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
    |> split("\n\n")
    |> reduce(%{vertical: 0, horizontal: 0}, fn matrix, acc ->
      matrix =
        matrix
        |> trim()
        |> split("\n")
        |> map(&codepoints/1)

      original_horizontal_mirror = find_mirror_index(matrix, 1, %{found: false, size: 0})

      horizontal_mirror =
        find_mirror_index_2(matrix, original_horizontal_mirror, 1, %{found: false, size: 0})

      original_vertical_mirror =
        matrix |> transpose() |> find_mirror_index(1, %{found: false, size: 0})

      vertical_mirror =
        matrix
        |> transpose()
        |> find_mirror_index_2(original_vertical_mirror, 1, %{found: false, size: 0})

      cond do
        horizontal_mirror.found ->
          %{acc | horizontal: acc.horizontal + horizontal_mirror.size}

        vertical_mirror.found ->
          %{acc | vertical: acc.vertical + vertical_mirror.size}
      end
    end)
    |> then(fn acc ->
      acc.vertical + 100 * acc.horizontal
    end)
  end

  def find_mirror_index_2(matrix, _original_horizontal_mirror, curr_index, result)
      when curr_index == length(matrix) do
    result
  end

  def find_mirror_index_2(matrix, %{found: true, size: size}, curr_index, result)
      when curr_index == size do
    find_mirror_index_2(matrix, %{found: true, size: size}, curr_index + 1, result)
  end

  def find_mirror_index_2(matrix, original_horizontal_mirror, curr_index, result) do
    part_1 = Enum.slice(matrix, 0..(curr_index - 1))
    part_2 = Enum.slice(matrix, curr_index, length(matrix))

    kek =
      reduce(0..(length(part_1) - 1), %{reflected: true, size: 0}, fn i, acc ->
        cond do
          !acc.reflected ->
            acc

          i >= length(part_2) ->
            %{acc | size: acc.size + 1}

          at(part_1, -1 - i) == at(part_2, i) ->
            %{acc | size: acc.size + 1}

          true ->
            one = at(part_1, -1 - i)
            two = at(part_2, i)

            diff_count =
              reduce(0..(length(one) - 1), 0, fn i, acc ->
                if at(one, i) != at(two, i) do
                  acc + 1
                else
                  acc
                end
              end)

            if diff_count == 1 do
              %{acc | size: acc.size + 1}
            else
              %{acc | reflected: false}
            end
        end
      end)

    result =
      if kek.reflected && kek.size > result.size do
        %{result | found: true, size: kek.size}
      else
        result
      end

    find_mirror_index_2(matrix, original_horizontal_mirror, curr_index + 1, result)
  end
end

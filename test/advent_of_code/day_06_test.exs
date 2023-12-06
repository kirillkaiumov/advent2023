defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = [
      {7, 9},
      {15, 40},
      {30, 200}
    ]

    result = part1(input)

    assert result == 288
  end

  test "part2" do
    input = {71530, 940_200}
    result = part2(input)

    assert result
  end
end

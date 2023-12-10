defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  @tag :skip
  test "part1" do
    input = """
    7-F7-
    .FJ|7
    FJLL7
    |F--J
    LJ.LJ
    """

    result = part1(input, {2, 0}, :north)

    assert result == 8
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input, {2, 0}, :west)

    assert result
  end
end

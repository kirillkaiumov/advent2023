defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "part1" do
    input = """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

    result = part1(input)

    assert result == 374
  end

  test "part2" do
    input = """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

    assert part2(input, 2) == 374
    assert part2(input, 10) == 1030
    assert part2(input, 100) == 8410
  end
end

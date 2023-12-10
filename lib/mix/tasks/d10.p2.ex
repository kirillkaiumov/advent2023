defmodule Mix.Tasks.D10.P2 do
  use Mix.Task

  import AdventOfCode.Day10

  @shortdoc "Day 10 Part 2"
  def run(args) do
    input = AdventOfCode.Input.get!(10, 2023)

    input
    |> part2({0, 0}, :west)
    |> IO.inspect(label: "Part 2 Results")
  end
end

defmodule Mix.Tasks.D10.P1 do
  use Mix.Task

  import AdventOfCode.Day10

  @shortdoc "Day 10 Part 1"
  def run(args) do
    input = AdventOfCode.Input.get!(10, 2023)

    input
    |> part1({82, 222}, :east)
    |> IO.inspect(label: "Part 1 Results")
  end
end

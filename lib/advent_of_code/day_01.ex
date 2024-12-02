defmodule AdventOfCode.Day01 do
  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ~r/\s+/))
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
    |> Enum.reduce([[], []], fn [a, b], [list_a, list_b] ->
      [[a | list_a], [b | list_b]]
    end)
  end

  def part1(args) do
    args
    |> parse()
    |> then(fn [list_a, list_b] -> [Enum.sort(list_a), Enum.sort(list_b)] end)
    |> Enum.zip()
    |> Enum.reduce(0, fn {a, b}, acc -> acc + abs(a - b) end)
  end

  def part2(args) do
    args
    |> parse()
    |> then(fn [list_a, list_b] -> [list_a, Enum.frequencies(list_b)] end)
    |> then(fn [list_a, freq] ->
      Enum.reduce(list_a, 0, fn a, acc -> acc + a * Map.get(freq, a, 0) end)
    end)
  end
end

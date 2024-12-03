defmodule AdventOfCode.Day02 do
  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp is_safe_report?(levels) do
    differences =
      levels
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    increasing = Enum.all?(differences, &(&1 >= 1 && &1 <= 3))
    decreasing = Enum.all?(differences, &(&1 <= -1 && &1 >= -3))

    increasing || decreasing
  end

  def part1(args) do
    args
    |> parse()
    |> Enum.filter(&is_safe_report?/1)
    |> Enum.count()
  end

  defp safe_with_dampener?(levels) do
    Enum.any?(0..(length(levels) - 1), fn i ->
      remaining_levels = List.delete_at(levels, i)
      is_safe_report?(remaining_levels)
    end)
  end

  def part2(args) do
    args
    |> parse()
    |> Enum.filter(fn levels ->
      is_safe_report?(levels) || safe_with_dampener?(levels)
    end)
    |> Enum.count()
  end
end

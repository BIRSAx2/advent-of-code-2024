defmodule AdventOfCode.Day01 do
  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.unzip()
  end

  def part1(args) do
    {list_a, list_b} = parse(args)

    list_a
    |> Enum.sort()
    |> Enum.zip(Enum.sort(list_b))
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2(args) do
    {list_a, list_b} = parse(args)
    freq_map = Enum.frequencies(list_b)

    Enum.reduce(list_a, 0, fn a, acc -> acc + a * Map.get(freq_map, a, 0) end)
  end
end
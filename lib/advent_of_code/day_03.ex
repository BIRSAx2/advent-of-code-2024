defmodule AdventOfCode.Day03 do
  @regex_part_1 ~r/mul\(\d+,\d+\)/
  @regex_part_2 ~r/mul\(\d+,\d+\)|do\(\)|don't\(\)/

  defp do_mul(ops) do
    ops
    |> Enum.map(&Regex.replace(~r/(mul|\(|\))/, &1, ""))
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.reduce(0, fn {a, b}, acc -> a * b + acc end)
  end

  def part1(args) do
    Regex.scan(@regex_part_1, args)
    |> List.flatten()
    |> do_mul()
  end

  def part2(args) do
    Regex.scan(@regex_part_2, args)
    |> List.flatten()
    |> Enum.reduce({[], true}, fn op, {ops, active} ->
      cond do
        op == "do()" -> {ops, true}
        op == "don't()" -> {ops, false}
        active -> {[op | ops], active}
        true -> {ops, active}
      end
    end)
    |> then(fn {ops, _} -> ops end)
    |> do_mul()
  end
end

defmodule AdventOfCode.Day07 do
  @operations_part1 [:+, :*]
  @operations_part2 [:+, :*, :"||"]

  def part1(args) do
    args
    |> parse()
    |> Enum.filter(&equation_valid?(&1, @operations_part1))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse()
    |> Enum.filter(&equation_valid?(&1, @operations_part2))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      case String.split(line, ": ", parts: 2) do
        [test_value_str, numbers_str] ->
          test_value = String.to_integer(test_value_str)
          numbers = String.split(numbers_str, ~r/\s+/, trim: true) |> Enum.map(&String.to_integer/1)
          {test_value, numbers}

        _ ->
          {:error, "Invalid line format: #{line}"}
      end
    end)
    |> Enum.filter(fn
      {:error, _} -> false
      _ -> true
    end)
  end

  defp equation_valid?({test_value, numbers}, allowed_operations) do
    operators = generate_operator_combinations(length(numbers) - 1, allowed_operations)

    Enum.any?(operators, fn ops ->
      evaluate_expression(numbers, ops) == test_value
    end)
  end

  defp generate_operator_combinations(0, _operations), do: [[]]

  defp generate_operator_combinations(n, operations) do
    Enum.reduce(1..n, [[]], fn _, acc ->
      acc
      |> Enum.flat_map(fn combo ->
        Enum.map(operations, fn op ->
          combo ++ [op]
        end)
      end)
    end)
  end

  defp evaluate_expression([first | rest], operators) do
    Enum.zip(rest, operators)
    |> Enum.reduce(first, fn {num, op}, acc ->
      apply_operator(acc, op, num)
    end)
  end

  defp apply_operator(a, :+, b), do: a + b
  defp apply_operator(a, :*, b), do: a * b
  defp apply_operator(a, :"||", b), do: concat(a, b)

  defp concat(a, b) do
    String.to_integer("#{a}#{b}")
  end
end

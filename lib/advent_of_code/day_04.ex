defmodule AdventOfCode.Day04 do

  def part1(args) do
    rows = parse(args)
    pattern = "XMAS"
    row_counts = sum_counts(rows, pattern)
    column_counts = rows |> transpose() |> sum_counts(pattern)
    diagonals_lr = rows |> get_diagonals_lr() |> sum_counts(pattern)
    diagonals_rl = rows |> get_diagonals_rl() |> sum_counts(pattern)

    row_counts + column_counts + diagonals_lr + diagonals_rl
  end

  def part2(args) do
    rows = parse(args)
    count_xmas(rows)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp transpose(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp get_diagonals_lr(rows) do
    max_diag = length(rows) + length(hd(rows)) - 2

    0..max_diag
    |> Enum.map(fn diag ->
      for i <- 0..diag,
          j = diag - i,
          i < length(rows),
          j < length(hd(rows)),
          do: Enum.at(rows, i) |> Enum.at(j)
    end)
    |> Enum.reject(&(&1 == []))
  end

  defp get_diagonals_rl(rows) do
    width = length(hd(rows)) - 1
    max_diag = length(rows) + length(hd(rows)) - 2

    0..max_diag
    |> Enum.map(fn diag ->
      for i <- 0..diag,
          j = diag - i,
          i < length(rows),
          j < length(hd(rows)),
          do: Enum.at(rows, i) |> Enum.at(width - j)
    end)
    |> Enum.reject(&(&1 == []))
  end

  defp count_occurrences(text, pattern) do
    regex = ~r/#{Regex.escape(pattern)}/
    Regex.scan(regex, text) |> length()
  end

  defp count_both_ways(text, pattern) do
    count_occurrences(text, pattern) + count_occurrences(text, String.reverse(pattern))
  end

  defp sum_counts(sequences, pattern) do
    sequences
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&count_both_ways(&1, pattern))
    |> Enum.sum()
  end

  defp count_xmas(rows) do
    height = length(rows)
    width = length(hd(rows))

    # Iterate through each cell to find potential centers ('A')
    (for y <- 0..(height - 1), x <- 0..(width - 1), do: {x, y})
    |> Enum.filter(fn {x, y} -> is_center?(rows, x, y) end)
    |> length()
  end

  defp is_center?(rows, x, y) do
    center = get_cell(rows, x, y)

    if center != "A" do
      false
    else
      # Check Top-Left to Bottom-Right diagonal
      diag1 = for i <- -1..1, do: get_cell(rows, x + i, y + i)
      # Check Top-Right to Bottom-Left diagonal
      diag2 = for i <- -1..1, do: get_cell(rows, x - i, y + i)

      match_pattern?(diag1) and match_pattern?(diag2)
    end
  end

  defp get_cell(_rows, x, y) when x < 0 or y < 0, do: nil
  defp get_cell(rows, x, y) do
    if y < length(rows) and x < length(Enum.at(rows, y)) do
      Enum.at(Enum.at(rows, y), x)
    else
      nil
    end
  end

  defp match_pattern?(["M", "A", "S"]), do: true
  defp match_pattern?(["S", "A", "M"]), do: true
  defp match_pattern?(_), do: false
end

defmodule AdventOfCode.Day05 do
  def part1(args) do
    {ordering_rules, page_numbers} = parse(args)

    page_numbers
    |> Enum.filter(&is_correctly_ordered(&1, ordering_rules))
    |> Enum.map(fn line ->
      middle = floor(Enum.count(line) / 2)
      Enum.at(line, middle, nil)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    {ordering_rules, page_numbers} = parse(args)

    page_numbers
    |> Enum.reject(&is_correctly_ordered(&1, ordering_rules))
    |> Enum.map(&reorder(&1, ordering_rules))
    |> Enum.map(fn line ->
      middle = floor(Enum.count(line) / 2)
      Enum.at(line, middle)
    end)
    |> Enum.sum()
  end

  defp is_correctly_ordered(line, ordering_rules) do
    Enum.all?(ordering_rules, fn [a, b] ->
      a_index = Enum.find_index(line, &(&1 == a))
      b_index = Enum.find_index(line, &(&1 == b))

      if is_nil(a_index) or is_nil(b_index) do
        true
      else
        a_index < b_index
      end
    end)
  end

  defp parse(args) do
    [ordering_rules, page_numbers] = String.split(args, "\n\n", parts: 2)

    ordering_rules =
      ordering_rules
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))

    page_numbers =
      page_numbers
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))

    {ordering_rules, page_numbers}
  end

  defp reorder(line, ordering_rules) do
    relevant_rules =
      Enum.filter(ordering_rules, fn [a, b] ->
        a in line and b in line
      end)

    graph = build_graph(line, relevant_rules)

    topological_sort(line, graph)
  end

  defp build_graph(pages, rules) do
    graph =
      pages
      |> Enum.map(&{&1, []})
      |> Enum.into(%{})

    Enum.reduce(rules, graph, fn [a, b], acc ->
      Map.update!(acc, a, fn adj -> [b | adj] end)
    end)
  end

  defp topological_sort(nodes, graph) do
    indeg = indegrees(nodes, graph)
    queue = for {node, 0} <- indeg, do: node
    kahn(queue, graph, indeg, [])
  end

  defp kahn([], _graph, _indeg, result), do: result
  defp kahn([h | t], graph, indeg, result) do
    neighbors = Map.get(graph, h, [])
    {new_indeg, new_queue} =
      Enum.reduce(neighbors, {indeg, t}, fn v, {i_acc, q_acc} ->
        updated_val = i_acc[v] - 1
        i_acc = Map.put(i_acc, v, updated_val)

        if updated_val == 0 do
          {i_acc, q_acc ++ [v]}
        else
          {i_acc, q_acc}
        end
      end)

    kahn(new_queue, graph, new_indeg, result ++ [h])
  end

  defp indegrees(nodes, graph) do
    indeg =
      nodes
      |> Enum.map(&{&1, 0})
      |> Enum.into(%{})

    Enum.reduce(graph, indeg, fn {_node, neighbors}, acc ->
      Enum.reduce(neighbors, acc, fn n, acc_inner ->
        Map.update!(acc_inner, n, &(&1 + 1))
      end)
    end)
  end
end

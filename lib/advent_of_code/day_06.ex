defmodule AdventOfCode.Day06 do
  @directions [
    {:up,    {-1, 0}},
    {:right, {0, 1}},
    {:down,  {1, 0}},
    {:left,  {0, -1}}
  ]

  def part1(input) do
    positions_map = parse(input)
    {_, _, visited} = simulate(positions_map)
    MapSet.size(visited)
  end

  def part2(input) do
    positions_map = parse(input)
    {guard_pos, direction, visited} = simulate(positions_map)

    visited_positions = MapSet.to_list(visited)

    visited_positions =
      visited_positions
      |> Enum.reject(&(&1 == guard_pos))

    loop_count =
      visited_positions
      |> Enum.reduce(0, fn pos, acc ->
        if causes_loop?(positions_map, pos, guard_pos) do
          acc + 1
        else
          acc
        end
      end)

    loop_count
  end

  defp parse(args) do
    rows =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    positions_map =
      for {line, row} <- Enum.with_index(rows),
          {cell, col} <- Enum.with_index(line),
          into: %{} do
        cell_type =
          case cell do
            "." -> :open
            "#" -> :wall
            "^" -> {:guard, :up}
            ">" -> {:guard, :right}
            "v" -> {:guard, :down}
            "<" -> {:guard, :left}
            _ -> :open
          end

        {{row, col}, cell_type}
      end

    positions_map
  end

  defp simulate(positions_map) do
    {max_row, max_col} = boundaries(positions_map)
    {guard_pos, {:guard, facing}} = find_guard(positions_map)
    direction = facing_to_vector(facing)

    visited = MapSet.new([guard_pos])
    current_pos = guard_pos
    current_dir = direction

    Enum.reduce_while(Stream.cycle([:step]), {current_pos, current_dir, visited}, fn _, {pos, dir, visited_acc} ->
      next = next_cell(pos, dir)

      cond do
        out_of_bounds?(next, max_row, max_col) ->
          {:halt, {pos, dir, visited_acc}}

        obstacle?(positions_map, next) ->
          new_dir = turn_right(dir)
          {:cont, {pos, new_dir, visited_acc}}

        true ->
          new_pos = next
          new_visited = MapSet.put(visited_acc, new_pos)
          {:cont, {new_pos, dir, new_visited}}
      end
    end)
  end

  defp causes_loop?(positions_map, obstruction_pos, guard_start) do
    orig = Map.get(positions_map, obstruction_pos, :open)
    if orig == :open do
      new_map = Map.put(positions_map, obstruction_pos, :wall)
      result = simulate_with_loop_detection(new_map)
      result
    else
      false
    end
  end

  defp simulate_with_loop_detection(positions_map) do
    {max_row, max_col} = boundaries(positions_map)
    {guard_pos, {:guard, facing}} = find_guard(positions_map)
    direction = facing_to_vector(facing)

    visited_states = MapSet.new([{guard_pos, direction}])

    current_pos = guard_pos
    current_dir = direction

    Enum.reduce_while(Stream.cycle([:step]), {current_pos, current_dir, visited_states}, fn _, {pos, dir, states} ->
      next = next_cell(pos, dir)

      cond do
        out_of_bounds?(next, max_row, max_col) ->
          {:halt, false}

        obstacle?(positions_map, next) ->
          new_dir = turn_right(dir)
          new_state = {pos, new_dir}

          if MapSet.member?(states, new_state) do
            {:halt, true}
          else
            {:cont, {pos, new_dir, MapSet.put(states, new_state)}}
          end

        true ->
          new_pos = next
          new_state = {new_pos, dir}

          if MapSet.member?(states, new_state) do
            {:halt, true}
          else
            {:cont, {new_pos, dir, MapSet.put(states, new_state)}}
          end
      end
    end)
  end

  defp boundaries(positions_map) do
    positions_map
    |> Map.keys()
    |> Enum.reduce({0,0}, fn {r,c}, {mr,mc} -> {max(mr,r), max(mc,c)} end)
  end

  defp find_guard(positions_map) do
    Enum.find(positions_map, fn {_, val} -> match?({:guard, _}, val) end)
  end

  defp facing_to_vector(facing) do
    {_f, vec} = Enum.find(@directions, fn {f, _v} -> f == facing end)
    vec
  end

  defp next_cell({r, c}, {dr, dc}), do: {r + dr, c + dc}

  defp obstacle?(positions_map, pos) do
    Map.get(positions_map, pos, :open) == :wall
  end

  defp out_of_bounds?({r, c}, max_row, max_col) do
    r < 0 or c < 0 or r > max_row or c > max_col
  end

  defp turn_right({dr, dc}) do
    order = [:up, :right, :down, :left]
    {facing, _} = Enum.find(@directions, fn {_, vec} -> vec == {dr, dc} end)
    idx = Enum.find_index(order, &(&1 == facing))
    new_facing = Enum.at(order, rem(idx + 1, length(order)))
    facing_to_vector(new_facing)
  end
end

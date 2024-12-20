defmodule Day08 do
  # reads file and returns a map of maps
  defp read_file(file_path) do
    File.stream!(file_path)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes(&1))
    |> Enum.with_index()
    |> Enum.into(%{}, fn {value, index} ->
      {index,
       value
       |> Enum.with_index()
       |> Enum.into(%{}, fn {value, index} -> {index, value} end)}
    end)
  end

  # number of antinodes between 2 points
  defp antinode_positions(map, {y1, x1}, {y2, x2}) do
    diff_x = abs(x1 - x2)
    diff_y = abs(y1 - y2)

    possible_locations =
      cond do
        # point 1 is above right to point 2
        y1 < y2 && x1 > x2 -> [{y1 - diff_y, x1 + diff_x}, {y2 + diff_y, x2 - diff_x}]
        # point 1 is above left to point 2
        y1 < y2 && x1 < x2 -> [{y1 - diff_y, x1 - diff_x}, {y2 + diff_y, x2 + diff_x}]
        # point 1 is below right to point 2
        y1 > y2 && x1 > x2 -> [{y1 + diff_y, x1 + diff_x}, {y2 - diff_y, x2 - diff_x}]
        # point 1 is below left to point 2
        y1 > y2 && x1 < x2 -> [{y1 + diff_y, x1 - diff_x}, {y2 - diff_y, x2 + diff_x}]
      end

    possible_locations
    # remove antinodes outside the map
    |> Enum.filter(fn {y, x} -> map[y][x] != nil end)
  end

  defp combinations([head | tail], acc) do
    if tail == [] do
      acc
    else
      [Enum.map(tail, fn x -> [head, x] end) | combinations(tail, acc)]
    end
  end

  defp calculate_antinodes(pos_map, map) do
    pos_map
    |> Map.keys()
    |> Enum.map(fn x -> combinations(pos_map[x], []) end)
    |> List.flatten()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [pos1, pos2] -> antinode_positions(map, pos1, pos2) end)
    |> List.flatten()
    |> Enum.uniq()
    |> length()
  end

  defp all_coords(map) do
    Enum.reduce(map, %{}, fn {ky, line}, acc ->
      Enum.reduce(line, acc, fn {kx, value}, acc ->
        cond do
          value == "." -> acc
          acc[value] == nil -> Map.put(acc, value, [{ky, kx}])
          true -> %{acc | value => [{ky, kx} | acc[value]]}
        end
      end)
    end)
  end

  def part_1(file_path) do
    map = read_file(file_path)

    all_coords(map)
    |> calculate_antinodes(map)
  end

  def part_2(_args) do
    "TBD"
  end
end

IO.puts("Part 1 - example: #{Day08.part_1("example.txt")}")
IO.puts("Part 1 - input: #{Day08.part_1("input.txt")}")
# IO.puts("Part 2 - example: #{Day08.part_2("example.txt")}")
# IO.puts("Part 2 - input: #{Day08.part_2("input.txt")}")

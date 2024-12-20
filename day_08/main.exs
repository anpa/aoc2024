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

  # antinode positions between 2 points (max 2)
  defp calculate_antinodes(map, {y1, x1}, {y2, x2}) do
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

  # all antinode positions in a line
  defp calculate_antinodes_in_line(map, {y1, x1}, {y2, x2}) do
    # Linear equation: y = a × x + b
    # a = (y2-y1) / (x2-x1)
    # b = y1 - a × x1
    max_x = length(Map.keys(map[0]))
    max_y = length(Map.keys(map))

    a = (y2 - y1) / (x2 - x1)
    b = y1 - a * x1

    Enum.map(0..max_x, fn x ->
      {a * x + b, x}
    end)
    |> Enum.filter(fn {y, _x} -> y == trunc(y) && y >= 0 && y < max_y end)
  end

  defp combinations([head | tail], acc) do
    if tail == [] do
      acc
    else
      [Enum.map(tail, fn x -> [head, x] end) | combinations(tail, acc)]
    end
  end

  defp get_antinodes(antenna_combinations, map, func) do
    antenna_combinations
    |> Enum.reduce(%{}, fn {freq, combinations}, acc ->
      positions =
        Enum.map(combinations, fn [pos1, pos2] -> func.(map, pos1, pos2) end)

      Map.put(acc, freq, positions)
    end)
  end

  defp get_antenna_combinations(antennas) do
    antennas
    |> Enum.reduce(%{}, fn {freq, positions}, acc ->
      combs =
        combinations(positions, [])
        |> List.flatten()
        |> Enum.chunk_every(2)

      Map.put(acc, freq, combs)
    end)
  end

  defp get_antennas(map) do
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

  defp number_of_unique_locations(antinodes) do
    antinodes
    |> Map.values()
    |> List.flatten()
    |> Enum.uniq()
    |> length()
  end

  def part_1(file_path) do
    map = read_file(file_path)

    get_antennas(map)
    |> get_antenna_combinations()
    |> get_antinodes(map, &calculate_antinodes/3)
    |> number_of_unique_locations()
  end

  def part_2(file_path) do
    map = read_file(file_path)

    get_antennas(map)
    |> IO.inspect(label: "antennas")
    |> get_antenna_combinations()
    |> IO.inspect(label: "combination")
    |> get_antinodes(map, &calculate_antinodes_in_line/3)
    |> IO.inspect(label: "antinodes")
    |> number_of_unique_locations()
  end
end

# IO.puts("Part 1 - example: #{Day08.part_1("example.txt")}")
# IO.puts("Part 1 - input: #{Day08.part_1("input.txt")}")
IO.puts("Part 2 - example: #{Day08.part_2("example.txt")}")
IO.puts("Part 2 - input: #{Day08.part_2("input.txt")}")

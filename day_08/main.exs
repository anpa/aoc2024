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

  # calculates the next antinode given two points
  # pn = p1 + (p1 - p2)
  defp calculate_antinode({y1, x1}, {y2, x2}) do
    {y1 + (y1 - y2), x1 + (x1 - x2)}
  end

  # returns false if point is outside the map
  defp out_of_bounds?({y, x}, map) do
    map[y][x] == nil
  end

  # takes two points and calculates the next antinode for x steps or until out of bounds
  defp next_antinode(map, pos1, pos2, acc, step \\ "infinite") do
    next_pos = calculate_antinode(pos1, pos2)

    cond do
      out_of_bounds?(next_pos, map) || step == 0 -> acc
      is_integer(step) -> next_antinode(map, next_pos, pos1, [next_pos | acc], step - 1)
      true -> next_antinode(map, next_pos, pos1, [next_pos | acc])
    end
  end

  # returns antinodes near 2 antennas in the map (max 2 antinodes)
  defp calculate_antinodes_nearby(map, pos1, pos2) do
    [
      next_antinode(map, pos1, pos2, [], 1),
      next_antinode(map, pos2, pos1, [], 1)
    ]
    |> List.flatten()
  end

  # returns all antinode positions given 2 antennas
  defp calculate_all_antinodes(map, pos1, pos2) do
    [
      next_antinode(map, pos1, pos2, [pos1]),
      next_antinode(map, pos2, pos1, [pos2])
    ]
    |> List.flatten()
  end

  defp antinodes(antennas, map, func) do
    antennas
    |> Enum.reduce(%{}, fn {freq, positions}, acc ->
      # calculate antinodes for each pair of antennas in the same frequency
      antinodes =
        for pos1 <- positions, pos2 <- positions, pos1 != pos2, do: func.(map, pos1, pos2)

      Map.put(acc, freq, antinodes)
    end)
  end

  defp antennas(map) do
    Enum.reduce(map, %{}, fn {ky, line}, acc ->
      Enum.reduce(line, acc, fn {kx, value}, acc ->
        if value == "." do
          acc
        else
          Map.update(acc, value, [{ky, kx}], fn existing -> [{ky, kx} | existing] end)
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

    antennas(map)
    |> antinodes(map, &calculate_antinodes_nearby/3)
    |> number_of_unique_locations()
  end

  def part_2(file_path) do
    map = read_file(file_path)

    antennas(map)
    |> antinodes(map, &calculate_all_antinodes/3)
    |> number_of_unique_locations()
  end
end

IO.puts("Part 1 - example: #{Day08.part_1("example.txt")}")
IO.puts("Part 1 - input: #{Day08.part_1("input.txt")}")
IO.puts("Part 2 - example: #{Day08.part_2("example.txt")}")
IO.puts("Part 2 - input: #{Day08.part_2("input.txt")}")

defmodule Day10 do
  # reads file and returns a map of maps
  defp read_file(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.into(%{}, fn {line, row_index} ->
      {row_index,
       Enum.with_index(line)
       |> Map.new(fn {char, col_index} -> {col_index, String.to_integer(char)} end)}
    end)
  end

  # Return the positions of all the trail heads (0)
  defp trailheads(map) do
    Enum.reduce(map, [], fn {ky, line}, acc ->
      Enum.reduce(line, acc, fn {kx, position}, acc ->
        if position == 0 do
          [{ky, kx} | acc]
        else
          acc
        end
      end)
    end)
    |> Enum.reverse()
  end

  # From a given trail head position, return a list all trails from 0 to 9
  def find_trails_from({y, x}, map, acc \\ []) do
    height = map[y][x]

    if height == 9 do
      [{y, x} | acc]
    else
      [
        # top
        map[y - 1][x] == height + 1 &&
          find_trails_from({y - 1, x}, map, [{y, x} | acc]),
        # right
        map[y][x + 1] == height + 1 &&
          find_trails_from({y, x + 1}, map, [{y, x} | acc]),
        # bottom
        map[y + 1][x] == height + 1 &&
          find_trails_from({y + 1, x}, map, [{y, x} | acc]),
        # left
        map[y][x - 1] == height + 1 &&
          find_trails_from({y, x - 1}, map, [{y, x} | acc])
      ]
      |> Enum.reject(fn x -> x == false end)
      |> List.flatten()
      |> Enum.chunk_every(10)
    end
  end

  def part_1(file_path) do
    map = read_file(file_path)

    trailheads(map)
    |> Enum.map(fn pos ->
      find_trails_from(pos, map)
      |> Enum.map(fn n -> List.first(n) end)
      |> Enum.uniq()
    end)
    |> Enum.map(fn x -> length(x) end)
    |> Enum.sum()
  end

  def part_2(file_path) do
    map = read_file(file_path)

    trailheads(map)
    |> Enum.map(fn pos -> find_trails_from(pos, map) end)
    |> Enum.map(fn x -> length(x) end)
    |> Enum.sum()
  end
end

IO.puts("Part 1 - example: #{Day10.part_1("example.txt")}")
IO.puts("Part 1 - input: #{Day10.part_1("input.txt")}")
IO.puts("Part 2 - example: #{Day10.part_2("example.txt")}")
IO.puts("Part 2 - input: #{Day10.part_2("input.txt")}")

defmodule Day04 do
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

  # counts the word 'XMAS' in every direction from a single point (y, x)
  def number_of_xmas(map, y, x) do
    [
      # right
      [map[y][x], map[y][x + 1], map[y][x + 2], map[y][x + 3]],
      # right-bottom
      [map[y][x], map[y + 1][x + 1], map[y + 2][x + 2], map[y + 3][x + 3]],
      # bottom
      [map[y][x], map[y + 1][x], map[y + 2][x], map[y + 3][x]],
      # left-bottom
      [map[y][x], map[y + 1][x - 1], map[y + 2][x - 2], map[y + 3][x - 3]],
      # left
      [map[y][x], map[y][x - 1], map[y][x - 2], map[y][x - 3]],
      # left-top
      [map[y][x], map[y - 1][x - 1], map[y - 2][x - 2], map[y - 3][x - 3]],
      # top
      [map[y][x], map[y - 1][x], map[y - 2][x], map[y - 3][x]],
      # right-top
      [map[y][x], map[y - 1][x + 1], map[y - 2][x + 2], map[y - 3][x + 3]]
    ]
    |> Enum.map(fn x ->
      x
      |> Enum.reject(&is_nil/1)
      |> Enum.join()
    end)
    |> Enum.reduce(0, fn line, acc -> length(Regex.scan(~r/XMAS/, line)) + acc end)
  end

  # counts the X's with the word 'MAS' in every direction from a single point (y, x)
  def number_of_x_mas(map, y, x) do
    [
      [map[y][x], map[y + 1][x + 1], map[y + 2][x + 2]],
      [map[y][x + 2], map[y + 1][x + 1], map[y + 2][x]]
    ]
    |> Enum.map(&Enum.join(&1))
    |> (fn [diagonal_1, diagonal_2] ->
          if diagonal_1 in ["MAS", "SAM"] && diagonal_2 in ["MAS", "SAM"] do
            1
          else
            0
          end
        end).()
  end

  def count_xmas(file_path) do
    almighty_map = read_file(file_path)

    Enum.reduce(almighty_map, 0, fn {ky, map}, acc ->
      Enum.reduce(map, acc, fn {kx, _}, acc ->
        acc + number_of_xmas(almighty_map, ky, kx)
      end)
    end)
  end

  def count_x_mas(file_path) do
    almighty_map = read_file(file_path)

    Enum.reduce(almighty_map, 0, fn {ky, map}, acc ->
      Enum.reduce(map, acc, fn {kx, _}, acc ->
        acc + number_of_x_mas(almighty_map, ky, kx)
      end)
    end)
  end
end

IO.puts("Part 1 - example: #{Day04.count_xmas("example.txt")}")
IO.puts("Part 1 - input: #{Day04.count_xmas("input.txt")}")
IO.puts("Part 2 - example: #{Day04.count_x_mas("example.txt")}")
IO.puts("Part 2 - input: #{Day04.count_x_mas("input.txt")}")

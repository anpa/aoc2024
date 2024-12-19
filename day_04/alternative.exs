defmodule Day04 do
  defp read_file(file_path) do
      File.stream!(file_path)
          |> Enum.map(&String.trim/1)
  end

  defp count_xmas_words_in_line(line) do
      result = Regex.scan(~r/XMAS/, line)
      result_rev = Regex.scan(~r/SAMX/, line)

      length(result) + length(result_rev)
  end

  defp count(lines) do
    Enum.reduce(lines, 0, fn line, acc -> count_xmas_words_in_line(line) + acc end)
  end

  defp horizontal_to_diagonal(line, acc, offset) do
      Stream.with_index(line, offset)
          |> Enum.reduce(acc, fn {v,k}, acc ->
              if acc[k] == nil do
                  Map.put(acc, k, [v])
              else
                  %{acc | k => [v| acc[k]]}
              end
          end)
  end

  defp vertical_lines(input) do
      input
          |> Enum.map(&String.graphemes(&1))
          |> Enum.zip() # Transpose
          |> Enum.map(&Tuple.to_list(&1) |> Enum.join())
  end

  defp diagonal_left_lines(input) do
      input
          |> Enum.map(&String.graphemes(&1))
          |> Enum.reduce({%{}, 0}, fn line, {map, counter} -> { horizontal_to_diagonal(line, map, counter), counter+1 } end)
          |> (fn {map, _} -> Map.values(map) end).()
          |> Enum.map(&Enum.join(&1))
  end

  defp diagonal_right_lines(input) do
      input
          |> Enum.map(&String.graphemes(&1))
          |> Enum.map(&Enum.reverse(&1))
          |> Enum.zip() # Transpose
          |> Enum.map(&Tuple.to_list(&1))
          |> Enum.reduce({%{}, 0}, fn line, {map, counter} -> { horizontal_to_diagonal(line, map, counter), counter+1 } end)
          |> (fn {map, _} -> Map.values(map) end).()
          |> Enum.map(&Enum.join(&1))
  end

  def count_xmas_words(file_path) do
      input = read_file(file_path)

      num_h = input
          |> count()

      num_v = input
          |> vertical_lines()
          |> count()

      num_dl = input
          |> diagonal_left_lines()
          |> count()

      num_dr = input
          |> diagonal_right_lines()
          |> count()

      num_h + num_v + num_dl + num_dr
  end

  def part_2() do
    "TBD"
  end
end

IO.puts("Part 1 - example: #{Day04.count_xmas_words("example.txt")}")
IO.puts("Part 1 - input: #{Day04.count_xmas_words("input.txt")}")
# IO.puts("Part 2 - example: #{Day04.part_2("example.txt")}")
# IO.puts("Part 2 - input: #{Day04.part_2("input.txt")}")

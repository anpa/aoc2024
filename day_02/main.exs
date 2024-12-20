defmodule Day02 do
  def split_and_parse(file_path) do
    File.stream!(file_path)
    |> Enum.reduce([], fn line, acc ->
      list =
        line
        |> String.trim()
        |> String.split(~r/\s+/)
        |> Enum.map(&String.to_integer/1)

      [list | acc]
    end)
    |> Enum.reverse()
  end

  def safe?(report) do
    diff =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    Enum.all?(diff, fn x -> x < 0 && x > -4 end) || Enum.all?(diff, fn x -> x > 0 && x < 4 end)
  end

  def safe_with_problem_dampener?(report) do
    # TODO: try without brute-force
    combinations =
      report
      |> Enum.with_index()
      |> Enum.map(fn {_, index} -> List.delete_at(report, index) end)

    Enum.any?(combinations, &safe?(&1))
  end

  def count_safe(file_path) do
    split_and_parse(file_path)
    |> Enum.count(&safe?(&1))
  end

  def count_safe_with_problem_dampener(file_path) do
    split_and_parse(file_path)
    |> Enum.count(fn x -> safe?(x) || safe_with_problem_dampener?(x) end)
  end
end

IO.puts("Part 1 - example: #{Day02.count_safe("example.txt")}")
IO.puts("Part 1 - input: #{Day02.count_safe("input.txt")}")
IO.puts("Part 2 - example: #{Day02.count_safe_with_problem_dampener("example.txt")}")
IO.puts("Part 2 - input: #{Day02.count_safe_with_problem_dampener("input.txt")}")

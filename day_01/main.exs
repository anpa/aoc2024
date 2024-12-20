defmodule Day01 do
  def split_and_parse(file_path) do
    File.stream!(file_path)
    |> Enum.reduce({[], []}, fn line, {acc_1, acc_2} ->
      line
      |> String.trim()
      |> String.split(~r/\s+/)
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn {result, _} -> result end)
      |> (fn [a, b] -> {[a | acc_1], [b | acc_2]} end).()
    end)
  end

  def total_distance(file_path) do
    {list_l, list_r} = split_and_parse(file_path)

    Enum.zip(Enum.sort(list_l), Enum.sort(list_r))
    |> Enum.map(fn {left, right} -> abs(right - left) end)
    |> Enum.sum()
  end

  def similarity_score(file_path) do
    {list_l, list_r} = split_and_parse(file_path)

    counts =
      Enum.reduce(list_r, %{}, fn x, acc ->
        if acc[x] == nil do
          Map.put(acc, x, 1)
        else
          %{acc | x => acc[x] + 1}
        end
      end)

    list_l
    |> Enum.map(fn x -> x * (counts[x] || 0) end)
    |> Enum.sum()
  end
end

IO.puts("Part 1 - example: #{Day01.total_distance("example.txt")}")
IO.puts("Part 1 - input: #{Day01.total_distance("input.txt")}")
IO.puts("Part 2 - example: #{Day01.similarity_score("example.txt")}")
IO.puts("Part 2 - input: #{Day01.similarity_score("input.txt")}")

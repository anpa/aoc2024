defmodule Day07 do
  # reads file and returns a [{total, [val1, val2, ...]}]
  defp read_file(file_path) do
    File.stream!(file_path)
    |> Enum.map(&String.trim(&1, "\n"))
    |> Enum.reduce([], fn line, acc ->
      [total | [rest]] = String.split(line, ": ")

      values =
        rest
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)

      [{String.to_integer(total), values} | acc]
    end)
  end

  defp combination(acc, list) do
    if list == [] do
      acc
    else
      [head | tail] = list
      [combination(acc + head, tail), combination(acc * head, tail)]
    end
  end

  def part_1(file_path) do
    read_file(file_path)
    |> Enum.map(fn {total, values} ->
      {total, combination(hd(values), tl(values)) |> List.flatten()}
    end)
    |> Enum.reduce(0, fn {total, values}, acc ->
      if total in values do
        acc + total
      else
        acc
      end
    end)
  end

  def part_2(_args) do
    "TBD"
  end
end

IO.puts("Part 1 - example: #{Day07.part_1("example.txt")}")
IO.puts("Part 1 - input: #{Day07.part_1("input.txt")}")
# IO.puts("Part 2 - example: #{Day07.part_2("example.txt")}")
# IO.puts("Part 2 - input: #{Day07.part_2("example.txt")}")

defmodule Day11 do
  require Integer
  # reads file and returns a map of maps
  defp read_file(file_path) do
    File.read!(file_path)
    |> String.split(" ")
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def even_number_of_digits?(num) do
    num
    |> Integer.to_string()
    |> String.length()
    |> Integer.is_even()
  end

  def split_in_half(num) do
    string = Integer.to_string(num)
    midpoint = div(String.length(string), 2)

    {
      String.slice(string, 0, midpoint) |> String.to_integer(),
      String.slice(string, midpoint, String.length(string) - 1) |> String.to_integer()
    }
  end

  def blink(map) do
    Map.keys(map)
    |> Enum.reduce(%{}, fn stone, acc ->
      cond do
        stone == 0 ->
          Map.update(acc, 1, map[stone], &(&1 + map[stone]))

        even_number_of_digits?(stone) ->
          {a, b} = split_in_half(stone)

          acc
          |> Map.update(a, map[stone], &(&1 + map[stone]))
          |> Map.update(b, map[stone], &(&1 + map[stone]))

        true ->
          Map.update(acc, stone * 2024, map[stone], &(&1 + map[stone]))
      end
    end)
  end

  def part_1(file_path) do
    stones =
      read_file(file_path)
      |> Enum.frequencies()

    1..25
    |> Enum.reduce(stones, fn _, acc -> blink(acc) end)
    |> Map.values()
    |> Enum.sum()
  end

  def part_2(file_path) do
    stones =
      read_file(file_path)
      |> Enum.frequencies()

    1..75
    |> Enum.reduce(stones, fn _, acc -> blink(acc) end)
    |> Map.values()
    |> Enum.sum()
  end
end

IO.puts("Part 1 - example: #{Day11.part_1("example.txt")}")
IO.puts("Part 1 - input: #{Day11.part_1("input.txt")}")
IO.puts("Part 2 - example: #{Day11.part_2("example.txt")}")
IO.puts("Part 2 - input: #{Day11.part_2("input.txt")}")

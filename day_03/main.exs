defmodule Day03 do
    def split_and_parse(file_path) do
        File.stream!(file_path)
            |> Enum.map(&String.trim(&1))
    end

    def calculate_multiplications(file_path) do
        split_and_parse(file_path)
            |> Enum.map(fn x -> Regex.scan(~r/mul\(([0-9]{1,3}),([0-9]{1,3})\)/, x) end)
            |> List.flatten()
            |> Enum.chunk_every(3)
            |> Enum.map(fn [_, first, second] ->
                String.to_integer(first) * String.to_integer(second)
              end)
            |> Enum.sum()
    end

    def part_2(_) do
        "TBD"
    end
end

IO.puts("Part 1 - example: #{Day03.calculate_multiplications("example.txt")}")
IO.puts("Part 1 - input: #{Day03.calculate_multiplications("input.txt")}")
#IO.puts("Part 2 - example: #{Day03.part_2("example.txt")}")
#IO.puts("Part 2 - input: #{Day03.part_2("input.txt")}")

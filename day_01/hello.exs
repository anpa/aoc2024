defmodule Day01 do
    def split_and_parse(file_path) do
        File.stream!(file_path)
            |> Enum.reduce({[], []}, fn line, {acc_1, acc_2} ->
                parts = line
                    |> String.trim()
                    |> String.split(~r/\s+/)
                    |> Enum.map(&Integer.parse/1)
                    |> Enum.map(fn {result, _} -> result end)

                first = List.first(parts)
                second = List.last(parts)

                { [first | acc_1], [second | acc_2] }
            end)
    end

    def calculate_value({a, b}) do
        Enum.zip(Enum.sort(a), Enum.sort(b))
            |> Enum.map(fn {a, b} -> abs(b - a) end)
            |> Enum.sum()
    end
end

result = Day01.split_and_parse("input.txt")
        |> Day01.calculate_value()

IO.inspect(result)

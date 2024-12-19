defmodule Day05 do
    defp read_file(file_path) do
        File.read!(file_path)
            |> String.split("\n\n")
            |> (fn [rules, updates] ->
                rules_parsed = rules
                    |> String.split("\n")
                    |> Enum.map(&String.split(&1, "|"))
                    |> Enum.reduce(%{}, fn [left, right], acc ->
                        Map.update(acc, left, [right], fn existing -> [right | existing] end)
                    end)

                updates_parsed = updates
                    |> String.split("\n")

                {rules_parsed, updates_parsed}
            end).()
    end

    def is_update_invalid(update, rules) do
        update
            |> String.split(",")
            |> Enum.any?(fn val ->
                [left, _] = String.split(update, val)
                values_after = rules[val] || []

                # is there any value on the left that should not be there
                values_after
                    |> Enum.any?(fn val -> String.contains?(left, val) end)
            end)
    end

    def get_correct_updates({rules, updates}) do
        updates
            |> Enum.reject(&is_update_invalid(&1, rules))
    end

    def get_middle_page(update) do
        list = String.split(update, ",")
        middle_index = list |> length() |> div(2)
        Enum.at(list, middle_index)
    end


    # sum of the middle page number from the correctly-ordered updates
    def part_1(file_path) do
        read_file(file_path)
            |> get_correct_updates()
            |> Enum.reduce(0, fn update, acc ->
                String.to_integer(get_middle_page(update)) + acc
            end)
    end

    def part_2(_) do
      "TBD"
    end
end

IO.puts("Part 1 - example: #{Day05.part_1("example.txt")}")
IO.puts("Part 1 - input: #{Day05.part_1("input.txt")}")
# IO.puts("Part 2 - example: #{Day05.part_2("example.txt")}")
# IO.puts("Part 2 - input: #{Day05.part_2("input.txt")}")
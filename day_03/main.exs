defmodule Day03 do
  require Integer
    defp read_file(file_path) do
        File.read!(file_path) |> String.trim()
    end

    defp multiply(a, b) do
        String.to_integer(a) * String.to_integer(b)
    end

    defp calculate_multiplications(input) do
        Regex.scan(~r/mul\(([0-9]{1,3}),([0-9]{1,3})\)/, input)
            |> Enum.reduce(0, fn [_, first, second], acc -> acc + multiply(first, second) end)
    end

    def process_file(file_path) do
        read_file(file_path)
            |> calculate_multiplications()
    end

    # Turns the input into a list of operations i.e. [["do(), input1], ["don't(), input2]]
    defp split_by_conditionals(input) do
        String.split(input, ~r/(do\(\)|don't\(\))/, include_captures: true)
            |> (fn list -> if List.first(list) in ["do()", "don't()"] do list else ["do()" | list] end end).()
            |> Enum.chunk_every(2)
    end

    def process_file_with_conditionals(file_path) do
        read_file(file_path)
            |> split_by_conditionals()
            |> Enum.reduce(0, fn [instruction, input], acc ->
                acc +
                  case instruction do
                    "do()" -> calculate_multiplications(input)
                    "don't()" -> 0
                    _ -> raise ArgumentError, "Invalid instruction: #{instruction}"
                  end
              end)
    end
end

IO.puts("Part 1 - example: #{Day03.process_file("example1.txt")}")
IO.puts("Part 1 - input: #{Day03.process_file("input.txt")}")
IO.puts("Part 2 - example: #{Day03.process_file_with_conditionals("example2.txt")}")
IO.puts("Part 2 - input: #{Day03.process_file_with_conditionals("input.txt")}")

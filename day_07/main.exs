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

  defp add(a, b) do
    a + b
  end

  defp multiply(a, b) do
    a * b
  end

  defp join(a, b) do
    (Integer.to_string(a) <> Integer.to_string(b))
    |> String.to_integer()
  end

  defp calculate(acc, list, operators) do
    if list == [] do
      acc
    else
      [head | tail] = list

      Enum.map(operators, fn operator ->
        calculate(operator.(acc, head), tail, operators)
      end)
    end
  end

  defp calculate_total_calibration(list) do
    Enum.reduce(list, 0, fn {total, _}, acc -> acc + total end)
  end

  defp valid_equation?({total, values}, operators) do
    possible_values =
      calculate(hd(values), tl(values), operators)
      |> List.flatten()

    total in possible_values
  end

  def part_1(file_path) do
    operators = [&add/2, &multiply/2]

    read_file(file_path)
    |> Enum.filter(&valid_equation?(&1, operators))
    |> calculate_total_calibration()
  end

  def part_2(file_path) do
    operators = [&add/2, &multiply/2, &join/2]

    read_file(file_path)
    |> Enum.filter(&valid_equation?(&1, operators))
    |> calculate_total_calibration()
  end
end

IO.puts("Part 1 - example: #{Day07.part_1("example.txt")}")
IO.puts("Part 1 - input: #{Day07.part_1("input.txt")}")
IO.puts("Part 2 - example: #{Day07.part_2("example.txt")}")
IO.puts("Part 2 - input: #{Day07.part_2("input.txt")}")

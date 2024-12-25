defmodule Day09 do
  require Integer

  def read_file(file_path) do
    File.read!(file_path)
  end

  # Receives a string of numbers and expands it into a list
  # "12304" -> [[0],[".", "."], [1, 1], [".", ".", "."], [2, 2, 2, 2]
  def expand(str) do
    str
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {n, i} ->
      val = if Integer.is_even(i), do: div(i, 2), else: "."
      List.duplicate(val, String.to_integer(n))
    end)
    |> Enum.reject(fn x -> x == [] end)
  end

  def remaining_space(space, file) do
    List.duplicate(".", length(space) - length(file))
  end

  def clear_space(list, file) do
    Enum.map(list, fn x ->
      if x == file, do: List.duplicate(".", length(file)), else: x
    end)
  end

  def move_file_blocks(list, files, acc \\ []) do
    cond do
      # no more files to process
      files == [] ->
        Enum.reverse(acc)

      # free space found
      hd(list) == "." ->
        move_file_blocks(
          tl(list),
          tl(files),
          [hd(files) | acc]
        )

      # file found
      true ->
        move_file_blocks(tl(list), List.delete(files, hd(list)), [hd(list) | acc])
    end
  end

  def move_files(list, files, acc \\ []) do
    cond do
      # no more files to process
      files == [] ->
        Enum.reverse(acc)
        |> List.flatten()

      # free space found
      "." in hd(list) ->
        # find the first file whose size is less or equal to the size of the free space
        file = Enum.find(files, fn x -> length(x) <= length(hd(list)) end)

        # free space is too smal
        if file == nil do
          move_files(tl(list), files, [hd(list) | acc])
        else
          move_files(
            [
              # add back remaining free space if any
              remaining_space(hd(list), file)
              # replace file that was moved with the same size of free space
              | clear_space(tl(list), file)
            ],
            List.delete(files, file),
            [file | acc]
          )
        end

      # file found
      true ->
        move_files(tl(list), List.delete(files, hd(list)), [hd(list) | acc])
    end
  end

  def checksum(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(0, fn {v, i}, acc ->
      if v == "." do
        acc
      else
        acc + i * v
      end
    end)
  end

  def part_1(str) do
    disk =
      str
      |> expand()
      |> List.flatten()

    file_blocks =
      disk
      |> Enum.filter(&(&1 != "."))
      |> Enum.reverse()

    move_file_blocks(disk, file_blocks)
    |> checksum()
  end

  def part_2(str) do
    disk = expand(str)

    files =
      disk
      |> Enum.filter(&(hd(&1) != "."))
      |> Enum.reverse()

    move_files(disk, files)
    |> checksum()
  end

  def test(part, arg, exp) do
    result = apply(__MODULE__, String.to_atom("part_#{part}"), [arg])
    color = if result == exp, do: IO.ANSI.green(), else: IO.ANSI.red()

    IO.puts([
      color,
      "Part #{part} with '#{arg}' - checksum #{result} - expected #{exp}",
      IO.ANSI.white()
    ])
  end
end

Day09.test(1, "2333133121414131402", 1928)
Day09.test(1, "2333133121414131499", 3630)
Day09.test(1, "714892711", 795)
Day09.test(1, "12101", 4)
Day09.test(1, "1313165", 69)
Day09.test(1, "12345", 60)
Day09.test(1, "12143", 17)
Day09.test(1, "14113", 16)
Day09.test(1, "121", 1)
Day09.test(1, "221", 2)
IO.puts("======")
Day09.test(2, "2333133121414131402", 2858)
Day09.test(2, "233313312141413140234", 4718)
Day09.test(2, "2333133121414131499", 6204)
Day09.test(2, "714892711", 813)
Day09.test(2, "12101", 4)
Day09.test(2, "1313165", 169)
Day09.test(2, "12345", 132)
Day09.test(2, "12143", 31)
Day09.test(2, "14113", 16)
Day09.test(2, "121", 1)
Day09.test(2, "221", 2)
Day09.test(2, "48274728818", 1752)
Day09.test(2, "13106", 91)
IO.puts("======")
IO.puts("Part 1 - example: #{Day09.part_1(Day09.read_file("example.txt"))}")
IO.puts("Part 1 - input: #{Day09.part_1(Day09.read_file("input.txt"))}")
IO.puts("Part 2 - example: #{Day09.part_2(Day09.read_file("example.txt"))}")
IO.puts("Part 2 - input: #{Day09.part_2(Day09.read_file("input.txt"))}")

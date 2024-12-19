defmodule Day06 do
    # reads file and returns a map of maps
    defp read_file(file_path) do
        File.stream!(file_path)
            |> Enum.map(&String.trim/1)
            |> Enum.map(&String.graphemes(&1))
            |> Enum.with_index()
            |> Enum.into(%{}, fn {value, index} ->
                {index, value
                    |> Enum.with_index()
                    |> Enum.into(%{}, fn {value, index} -> {index, value} end)
                }
            end)
    end

    defp get_start_coords(map) do
      Enum.reduce(map, {0,0}, fn {ky, line}, acc ->
        Enum.reduce(line, acc, fn {kx, position}, acc ->
           if position == "^" do {ky,kx} else acc end
        end)
      end)
    end

    defp next_coord({y,x}, dir) do
      case dir do
        "up" -> {y-1, x}
        "right" -> {y, x+1}
        "down" -> {y+1, x}
        "left" -> {y, x-1}
      end
    end

    defp next_dir(dir) do
        case dir do
            "up" -> "right"
            "right" -> "down"
            "down" -> "left"
            "left" -> "up"
        end
    end

    defp move(map, {y,x}, dir, visited) do
      {yn, xn} = next_coord({y,x}, dir)

      if map[yn][xn] == nil do
        visited
      else
        if map[yn][xn] == "#" do
            move(map, {y,x}, next_dir(dir), visited)
        else
            move(map, {yn,xn}, dir, [{yn,xn} | visited])
        end
      end
    end

    def part_1(file_path) do
        map = read_file(file_path)

        {yi, xi} = get_start_coords(map)
        visited = [{yi,xi}]
        dir = "up"

        visited = move(map, {yi, xi}, dir, visited)

        visited
            |> Enum.uniq()
            |> (fn list -> length(list) end).()
    end

    def part_2(_) do
        "TBD"
    end
end

IO.puts("Part 1 - example: #{Day06.part_1("example.txt")}")
IO.puts("Part 1 - input: #{Day06.part_1("input.txt")}")
# IO.puts("Part 2 - example: #{Day06.part_2("example.txt")}")
# IO.puts("Part 2 - input: #{Day06.part_2("input.txt")}")

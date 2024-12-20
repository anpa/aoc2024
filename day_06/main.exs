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

    defp move(map, pos, dir, visited) do
      {yn, xn} = next_coord(pos, dir)

      cond do
        # guard is exiting the map
        map[yn][xn] == nil ->
            visited
        # obstacle
        map[yn][xn] == "#" ->
            move(map, pos, next_dir(dir), visited)
        # move
        true ->
            move(map, {yn,xn}, dir, [{yn,xn} | visited])
      end
    end

    defp visited_positions(map) do
        {yi, xi} = get_start_coords(map)
        visited = [{yi,xi}]
        dir = "up"

        visited = move(map, {yi, xi}, dir, visited)

        visited
            |> Enum.uniq()
    end

    def part_1(file_path) do
        map = read_file(file_path)

        visited_positions(map)
            |> (fn list -> length(list) end).()
    end

    defp update_visited(visited, {x,y}, dir) do
        if visited[{x,y}] == nil do
            Map.put(visited, {x,y}, [dir])
        else
            %{visited | {x,y} => [dir | visited[{x,y}]]}
        end
    end

    defp is_repeated?(visited, {x,y}, dir) do
      Enum.member?(visited[{x,y}] || [], dir)
    end

    defp stuck_in_loop?(map, obstacle_pos, pos, dir, visited) do
        {yn, xn} = next_coord(pos, dir)
        dir_n = if map[yn][xn] == "#" || obstacle_pos == {yn,xn} do next_dir(dir) else dir end

        cond do
            # guard is exiting the map
            map[yn][xn] == nil ->
              false
            # guard is looping
            is_repeated?(visited, {yn,xn}, dir_n) ->
              true
            # obstacle
            dir_n != dir ->
                stuck_in_loop?(map, obstacle_pos, pos, dir_n, update_visited(visited, pos, dir))
            # move
            true ->
                stuck_in_loop?(map, obstacle_pos, {yn,xn}, dir, visited)
        end
    end

    def part_2(file_path) do
        map = read_file(file_path)
        {yi, xi} = get_start_coords(map)
        visited = %{}
        dir = "up"

        # place obstacle in one of the future guard positions
        # this way we don't need to brute-force positions that are not relevant
        visited_positions(map)
            |> Enum.filter(fn x -> x != {yi,xi} end) # exclude start point
            |> Enum.filter(fn obstacle_pos -> stuck_in_loop?(map, obstacle_pos, {yi, xi}, dir, visited) end)
            |> (fn list -> length(list) end).()
    end
end

defmodule Benchmark do
    def measure(function) do
      function
      |> :timer.tc
      |> elem(0)
      |> Kernel./(1_000_000)
    end
  end

IO.puts("Part 1 - example: #{Day06.part_1("example.txt")}")
IO.puts("Part 1 - input: #{Day06.part_1("input.txt")}")
IO.puts("Part 2 - example: #{Day06.part_2("example.txt")}")

# TODO - optimize running time
{time_in_microseconds, ret_val} = :timer.tc(fn -> Day06.part_2("input.txt") end)
IO.puts("Part 2 - input: #{ret_val} (in #{time_in_microseconds/1000000} seconds)")

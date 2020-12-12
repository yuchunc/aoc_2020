defmodule Day12 do
  @data File.read!("data/day12.txt")
        |> String.split("\n", trim: true)

  def task1(data \\ @data) do
    calc_manhattan_dist(data, Day12.Task1, "E")
  end

  def task2(data \\ @data) do
    calc_manhattan_dist(data, Day12.Task2, {10, 1})
  end

  def calc_manhattan_dist(data, mod, deviant, starting \\ {0, 0}) do
    {{x, y}, _} = Enum.reduce(data, {starting, deviant}, &apply(mod, :transcribe_cmd, [&1, &2]))
    abs(x) + abs(y)
  end
end

defmodule Day12.Task2 do
  def transcribe_cmd("N" <> str_val, {pos, {x, y}}) do
    {pos, {x, y + String.to_integer(str_val)}}
  end

  def transcribe_cmd("S" <> str_val, {pos, {x, y}}) do
    {pos, {x, y - String.to_integer(str_val)}}
  end

  def transcribe_cmd("E" <> str_val, {pos, {x, y}}) do
    {pos, {x + String.to_integer(str_val), y}}
  end

  def transcribe_cmd("W" <> str_val, {pos, {x, y}}) do
    {pos, {x - String.to_integer(str_val), y}}
  end

  def transcribe_cmd("L" <> str_val, {pos, waypoint}) do
    waypoint_1 =
      str_val
      |> String.to_integer()
      |> div(90)
      |> update_waypoint(waypoint, {-1, 1})

    {pos, waypoint_1}
  end

  def transcribe_cmd("R" <> str_val, {pos, waypoint}) do
    waypoint_1 =
      str_val
      |> String.to_integer()
      |> div(90)
      |> update_waypoint(waypoint, {1, -1})

    {pos, waypoint_1}
  end

  def transcribe_cmd("F0", acc), do: acc

  def transcribe_cmd("F" <> str_val, {{ship_x, ship_y}, {way_x, way_y} = waypoint}) do
    transcribe_cmd(
      "F#{String.to_integer(str_val) - 1}",
      {{ship_x + way_x, ship_y + way_y}, waypoint}
    )
  end

  defp update_waypoint(0, waypoint, _), do: waypoint

  defp update_waypoint(count, {w_x, w_y}, {adj_x, adj_y} = adj) do
    update_waypoint(count - 1, {w_y * adj_x, w_x * adj_y}, adj)
  end
end

defmodule Day12.Task1 do
  @orientations ["E", "S", "W", "N"]

  def transcribe_cmd("N" <> str_val, {{x, y}, f}) do
    {{x, y + String.to_integer(str_val)}, f}
  end

  def transcribe_cmd("S" <> str_val, {{x, y}, f}) do
    {{x, y - String.to_integer(str_val)}, f}
  end

  def transcribe_cmd("E" <> str_val, {{x, y}, f}) do
    {{x + String.to_integer(str_val), y}, f}
  end

  def transcribe_cmd("W" <> str_val, {{x, y}, f}) do
    {{x - String.to_integer(str_val), y}, f}
  end

  def transcribe_cmd(<<turn::binary-size(1)>> <> str_val, {pos, f}) when turn in ["L", "R"] do
    turn_counts =
      str_val
      |> String.to_integer()
      |> div(90)

    facing_1 =
      @orientations
      |> get_orientation({turn, turn_counts}, f)

    {pos, facing_1}
  end

  def transcribe_cmd("F" <> str_val, {pos, f}) do
    {pos_1, _} = transcribe_cmd(f <> str_val, {pos, f})

    {pos_1, f}
  end

  defp get_orientation(list, {"L", counts}, curr) do
    list
    |> Enum.reverse()
    |> get_orientation({nil, counts}, curr)
  end

  defp get_orientation(list, {_, counts}, curr) do
    list
    |> List.duplicate(2)
    |> List.flatten()
    |> Enum.drop_while(&(&1 != curr))
    |> Enum.at(counts)
  end
end

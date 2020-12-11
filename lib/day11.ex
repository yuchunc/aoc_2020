defmodule Day11 do
  @data File.read!("data/day11.txt")
        |> String.split("\n", trim: true)
        |> Enum.map(&String.graphemes/1)

  alias Day11.Task1
  alias Day11.Task2

  def task1(data \\ @data) do
    get_count(data, Task1)
  end

  def task2(data \\ @data) do
    get_count(data, Task2)
  end

  defp get_count(data, rule_module) do
    SeatServer.start_link(data)

    count =
      Stream.repeatedly(fn -> SeatServer.tick(rule_module) end)
      |> Stream.map(fn _ -> SeatServer.get_seats() end)
      |> Enum.reduce_while([], fn
        elem, elem -> {:halt, elem}
        elem, _ -> {:cont, elem}
      end)
      |> List.flatten()
      |> Enum.filter(&(&1 == "#"))
      |> Enum.count()

    SeatServer.stop()

    count
  end
end

defmodule SeatServer do
  use Agent

  def start_link(seats) do
    Agent.start_link(fn -> seats end, name: __MODULE__)
  end

  def get_seats do
    Agent.get(__MODULE__, & &1)
  end

  def tick(rule_module) do
    Agent.update(__MODULE__, &update_seats(&1, rule_module), 60 * 60 * 1000)
  end

  def stop do
    Agent.stop(__MODULE__)
  end

  defp update_seats(seats, rule_module), do: update_rows(seats, {0, 0}, [], seats, rule_module)

  defp update_rows([], _, acc, _, _), do: Enum.reverse(acc)

  defp update_rows([h | t], {row, _} = pos, acc, seats, rule_module) do
    update_rows(
      t,
      {row + 1, 0},
      [update_seat(h, pos, [], seats, rule_module) | acc],
      seats,
      rule_module
    )
  end

  defp update_seat([], _, acc, _, _), do: Enum.reverse(acc)

  defp update_seat(["." | t], {row, col}, acc, seats, rule_module),
    do: update_seat(t, {row, col + 1}, ["." | acc], seats, rule_module)

  defp update_seat([curr | t], {row, col} = pos, acc, seats, rule_module) do
    seated =
      apply(rule_module, :get_neighbours, [pos, seats])
      |> Enum.filter(&(&1 == "#"))
      |> Enum.count()

    update_seat(
      t,
      {row, col + 1},
      [apply(rule_module, :toggle_seating, [curr, seated]) | acc],
      seats,
      rule_module
    )
  end
end

defmodule Day11.Task1 do
  def toggle_seating("L", []), do: "#"
  def toggle_seating("#", seated) when length(seated) >= 4, do: "L"
  def toggle_seating(curr, _), do: curr

  def get_neighbours({row, col} = curr, seats) do
    for r <- (row - 1)..(row + 1), c <- (col - 1)..(col + 1) do
      {r, c}
    end
    |> Kernel.--([curr])
    |> Enum.reduce([], &get_seat(&1, &2, seats))
  end

  defp get_seat({row, col}, acc, seats) do
    cond do
      row >= 0 && row < Enum.count(seats) && col >= 0 && col < Enum.count(hd(seats)) ->
        [get_in(seats, [Access.at(row), Access.at(col)]) | acc]

      true ->
        acc
    end
  end
end

defmodule Day11.Task2 do
  @directions [{1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}]

  def toggle_seating("L", 0), do: "#"
  def toggle_seating("#", seated) when seated >= 5, do: "L"
  def toggle_seating(curr, _), do: curr

  def get_neighbours({row, col}, seats) do
    Enum.filter(@directions, fn {row_d, col_d} ->
      find_neighbour(
        {row_d, col_d},
        {row + row_d, col + col_d},
        seats,
        {Enum.count(seats) - 1, (hd(seats) |> Enum.count()) - 1}
      )
    end)
    |> Enum.map(fn _ -> "#" end)
  end

  def find_neighbour({row_d, col_d}, {row, col}, seats, {last_row, last_col})
      when row >= 0 and row <= last_row and col >= 0 and col <= last_col do
    case get_seat({row, col}, seats) do
      "#" -> true
      "L" -> false
      _ -> find_neighbour({row_d, col_d}, {row + row_d, col + col_d}, seats, {last_row, last_col})
    end
  end

  def find_neighbour(_, _, _, _), do: false

  defp get_seat({row, col}, seats) do
    get_in(seats, [Access.at(row), Access.at(col)])
  end
end


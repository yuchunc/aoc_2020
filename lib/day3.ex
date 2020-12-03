defmodule Day3 do
  @row_space 31

  @data File.read!("data/day3.txt")
        |> String.split("\n")

  def task1 do
    rule = {3, 1}
    traverse_row(@data, 0, rule, rule, 0)
  end

  def task2 do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(&traverse_row(@data, 0, &1, &1, 0))
    |> Enum.reduce(&*/2)
  end

  def traverse_row([], _, _, _, count), do: count

  def traverse_row([row | _] = rows, x_pos, {0, 0}, rule, count) do
    if String.at(row, x_pos) == "#" do
      traverse_row(rows, x_pos, rule, rule, count + 1)
    else
      traverse_row(rows, x_pos, rule, rule, count)
    end
  end

  def traverse_row([_ | t], x_pos, {0, y_shift}, rule, count) do
    traverse_row(t, x_pos, {0, y_shift - 1}, rule, count)
  end

  def traverse_row(rows, x_pos, {x_shift, y_shift}, rule, count) do
    traverse_row(rows, rem(x_pos + x_shift, @row_space), {0, y_shift}, rule, count)
  end
end

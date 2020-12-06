defmodule Day6 do
  @data File.read!("data/day6.txt")
        |> String.split("\n\n")

  def task1 do
    @data
    |> Enum.map(&task1_mapper/1)
    |> Enum.sum()
  end

  def task2 do
    @data
    |> Enum.map(&task2_mapper/1)
    |> Enum.sum()
  end

  defp task1_mapper(str) do
    str
    |> String.split(~r/(|\n)/, trim: true)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp task2_mapper(str) do
    String.split(str, "\n", trim: true)
    |> Enum.map(&(&1 |> String.graphemes() |> MapSet.new()))
    |> find_intersect
    |> Enum.count()
  end

  defp find_intersect([list]), do: list

  defp find_intersect([passenger1, passenger2 | t]) do
    find_intersect([MapSet.intersection(passenger1, passenger2) | t])
  end
end

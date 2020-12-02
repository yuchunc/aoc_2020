defmodule Day1 do
  @ints File.read!("data/day_1.txt")
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.to_integer/1)

  def task_1 do
    for n <- @ints, m <- @ints do
      if n + m == 2020 do
        n * m
      end
    end
    |> Enum.find(&(&1 != nil))
  end

  def task_2 do
    for n <- @ints, m <- @ints, l <- @ints do
      if n + m + l == 2020 do
        n * m * l
      end
    end
    |> Enum.find(&(&1 != nil))
  end
end

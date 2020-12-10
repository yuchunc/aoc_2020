defmodule Day10Test do
  use ExUnit.Case
  @data1 ~w(16 10 15 5 1 11 7 19 6 12 4)

  @data2 ~w(28 33 18 42 31 14 46 20 48 47 24 23 49 45 19 38 39 11 1 32 25 35 8 17 7 9 4 2 34 10 3)

  test "task1 validated with data1" do
    assert @data1 |> data |> Day10.task1() == 7 * 5
  end

  test "task1 validated with data2" do
    assert @data2 |> data |> Day10.task1() == 22 * 10
  end

  test "task2 validated with data1" do
    assert @data1 |> data |> Day10.task2() == 8
  end

  test "task2 validated with data2" do
    assert @data2 |> data |> Day10.task2() == 19208
  end

  defp data(data) do
    data
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end
end

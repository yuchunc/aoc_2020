defmodule Day11Test do
  use ExUnit.Case

  @data "L.LL.LL.LL\nLLLLLLL.LL\nL.L.L..L..\nLLLL.LL.LL\nL.LL.LL.LL\nL.LLLLL.LL\n..L.L.....\nLLLLLLLLLL\nL.LLLLLL.L\nL.LLLLL.LL\n"
        |> String.split("\n", trim: true)
        |> Enum.map(&String.graphemes/1)

  test "task1 with test data" do
    assert Day11.task1(@data) == 37
  end

  test "task2 with test data" do
    assert Day11.task2(@data) == 26
  end
end

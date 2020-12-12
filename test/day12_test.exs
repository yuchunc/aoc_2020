defmodule Day12Test do
  use ExUnit.Case

  @data ~w{F10 N3 F7 R90 F11}

  test "task1 is correct" do
    assert Day12.task1(@data) == 25
  end

  test "task2 is correct" do
    assert Day12.task2(@data) == 286
  end
end

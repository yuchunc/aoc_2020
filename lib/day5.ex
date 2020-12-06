defmodule Day5 do
  @data File.read!("data/day5.txt")
        |> String.trim()
        |> String.split("\n")

  @rows 0..127
  @columns 0..7

  def task1 do
    @data
    |> Enum.map(&transcribe_seat/1)
    |> Enum.map(&calc_id/1)
    |> Enum.max()
  end

  def task2 do
    [_, {row, seats}, _] =
      @data
      |> Enum.map(&transcribe_seat/1)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.filter(fn {_, seats} -> Enum.count(seats) != 8 end)
      |> Enum.sort(&(elem(&1, 0) < elem(&2, 0)))

    [column] = Enum.to_list(@columns) -- seats

    calc_id({row, column})
  end

  def task2_v2 do
    ids = Enum.map(@data, &binary_calc/1)

    Enum.min(ids)..Enum.max(ids)
    |> Enum.to_list()
    |> Kernel.--(ids)
  end

  defp binary_calc(str) do
    str
    |> String.replace(["F", "L"], "0")
    |> String.replace(["B", "R"], "1")
    |> String.to_integer(2)
  end

  defp transcribe_seat(cmd_str) do
    cmd_str
    |> spliter
    |> find_row
    |> find_column
  end

  defp spliter(str) do
    <<row_cmd::binary-size(7)>> <> column = str
    {row_cmd, column}
  end

  defp calc_id({row, column}) do
    row * 8 + column
  end

  defp find_row({row_cmd, column}) do
    {binary_search(row_cmd, @rows), column}
  end

  defp find_column({row, column_cmd}) do
    {row, binary_search(column_cmd, @columns)}
  end

  defp binary_search(cmd, _..last = range) do
    half = (last + 1) |> div(2)

    cmd
    |> String.graphemes()
    |> do_binary_search(Enum.chunk_every(range, half), half)
  end

  defp do_binary_search([cmd], [[target], _], 1) when cmd in ["F", "L"], do: target
  defp do_binary_search([cmd], [_, [target]], 1) when cmd in ["B", "R"], do: target

  defp do_binary_search([h | t], [lower, _], half) when h in ["F", "L"] do
    half_1 = div(half, 2)
    do_binary_search(t, Enum.chunk_every(lower, half_1), half_1)
  end

  defp do_binary_search([h | t], [_, upper], half) when h in ["B", "R"] do
    half_1 = div(half, 2)
    do_binary_search(t, Enum.chunk_every(upper, half_1), half_1)
  end
end

defmodule Day2 do
  def task_1 do
    load_data()
    |> Enum.reduce(0, &scan_for_range/2)
  end

  def task_2 do
    load_data()
    |> Enum.reduce(0, &scan_for_position/2)
  end

  defp scan_for_range({elem, range, code}, acc) do
    count =
      Regex.scan(~r/#{elem}/, code)
      |> Enum.count()

    if count in range do
      acc + 1
    else
      acc
    end
  end

  defp scan_for_position({elem, pos1..pos2, code}, acc) do
    char1 = String.at(code, pos1 - 1)
    char2 = String.at(code, pos2 - 1)

    cond do
      elem == char1 && elem == char2 ->
        acc

      char1 == elem || char2 == elem ->
        acc + 1

      true ->
        acc
    end
  end

  defp load_data do
    File.read!("data/day_2.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&adjust_data/1)
  end

  defp adjust_data(str) do
    [range_str, <<elem::binary-size(1)>> <> ":", code] = String.split(str, " ")

    {elem, get_range(range_str), code}
  end

  defp get_range(str) do
    [begin, fin] = String.split(str, "-")

    String.to_integer(begin)..String.to_integer(fin)
  end
end

defmodule Day10 do
  @data File.read!("data/day10.txt")
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sort()

  def task1(data \\ @data) do
    {_, {one_jolt, three_jolts}} =
      data
      |> Enum.reduce({0, {0, 1}}, &find_differences/2)

    one_jolt * three_jolts
  end

  def task2(data \\ @data) do
    [0 | data]
    |> Enum.chunk_while([], &chuncker/2, &after_fn/1)
    |> Enum.reduce(1, &count_paths/2)
  end

  defp find_differences(elem, {last, {one, three}}) do
    case elem - last do
      1 -> {elem, {one + 1, three}}
      3 -> {elem, {one, three + 1}}
    end
  end

  defp chuncker(elem, []), do: {:cont, [elem]}

  defp chuncker(elem, [h | _] = acc) when h + 1 == elem, do: {:cont, [elem | acc]}

  defp chuncker(elem, acc), do: {:cont, Enum.reverse(acc), [elem]}

  defp after_fn(acc), do: {:cont, acc, []}

  defp count_paths(list, acc) when length(list) in [1, 2], do: acc

  defp count_paths(list, acc) do
    count =
      translate_to_graph(list)
      |> Graph.get_paths(hd(list), List.last(list))
      |> Enum.count()

    count * acc
  end

  defp translate_to_graph(list, graph \\ Graph.new())

  defp translate_to_graph([_], graph), do: graph

  defp translate_to_graph(list, graph) do
    {[current | adapters], rest} = Enum.split(list, 4)

    a_tuples =
      for a <- adapters do
        {current, a}
      end

    translate_to_graph(adapters ++ rest, Graph.add_edges(graph, a_tuples))
  end
end

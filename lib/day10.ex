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
    device_jolt = List.last(data) + 3
    list = [0 | data] ++ [device_jolt]
    graph = translate_to_graph(list, Graph.new)

    Graph.get_paths(graph, 0, device_jolt)
    |> Enum.count
  end

  defp find_differences(elem, {last, {one, three}}) do
    case elem - last do
      1 -> {elem, {one + 1, three}}
      3 -> {elem, {one, three + 1}}
    end
  end

  defp translate_to_graph([_], graph), do: graph

  defp translate_to_graph(list, graph) do
    {[current | adapters], rest} = Enum.split(list, 4)

    graph_1 = Enum.reduce(adapters, graph, &add_to_graph(&1, current, &2))

    translate_to_graph(adapters ++ rest, graph_1)
  end

  defp add_to_graph(adapter, current, graph) when adapter - current <= 3 do
      Graph.add_edge(graph, current, adapter)
  end

  defp add_to_graph(_, _, graph), do: graph
end

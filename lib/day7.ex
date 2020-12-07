defmodule Day7 do
  @data File.read!("data/day7.txt")
        |> String.split("\n", trim: true)

  def task1 do
    graph = build_graph()

    graph
    |> :digraph.vertices()
    |> Enum.map(&:digraph.get_path(graph, &1, "shiny gold"))
    |> Enum.reject(&(&1 == false))
    |> Enum.count()
  end

  def task2(data \\ @data) do
    graph = build_graph(data)

    calc_vertex(1, "shiny gold", :digraph.out_edges(graph, "shiny gold"), graph)
    |> Kernel.-(1)
  end

  defp calc_vertex(in_count, _, [], _), do: in_count

  defp calc_vertex(in_count, at, edges, graph) do
    edges
    |> Enum.map(fn edge ->
      {_, ^at, to, count} = :digraph.edge(graph, edge)
      calc_vertex(count, to, :digraph.out_edges(graph, to), graph)
    end)
    |> Enum.sum()
    |> Kernel.*(in_count)
    |> Kernel.+(in_count)
  end

  defp build_graph(data \\ @data) do
    graph = :digraph.new()
    Enum.each(data, &(&1 |> String.split(" contain ") |> cast_to_graph(graph)))
    graph
  end

  defp cast_to_graph([_, "no other bags."], _), do: true

  defp cast_to_graph([bag, str], graph) do
    v1 = :digraph.add_vertex(graph, String.replace_trailing(bag, " bags", ""))

    Regex.scan(~r/(\d+) (\w+\s\w+)/, str)
    |> Enum.each(fn [_, str_count, bag] ->
      add_edge(v1, bag, String.to_integer(str_count), graph)
    end)
  end

  defp add_edge(v1, str, count, graph) do
    v2 = :digraph.add_vertex(graph, str)
    :digraph.add_edge(graph, v1, v2, count)
  end
end

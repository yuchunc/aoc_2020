defmodule Day9 do
  @data File.read!("data/day9.txt")
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)

  @task1_npre 25

  def task1 do
    find_errors(@data)
  end

  def task2 do
    [target] = find_errors(@data)
    range = find_contiguous_range(0..0, @data, target)
    Enum.min(range) + Enum.max(range)
  end

  defp find_contiguous_range(min..max = range, data, target) do
    range = Enum.slice(data, range)
    sum = Enum.sum(range)

    cond do
      sum == target -> range
      sum < target -> find_contiguous_range(min..(max + 1), data, target)
      sum > target -> find_contiguous_range((min + 1)..(min + 1), data, target)
    end
  end

  defp find_errors(data) do
    {pre, list} = Enum.split(data, @task1_npre)
    find_errors(list, pre, [])
  end

  defp find_errors([], _, acc), do: acc

  defp find_errors([h | t], pre, acc) do
    acc_1 =
      if h in gen_sums(pre) do
        acc
      else
        [h | acc]
      end

    pre_1 =
      pre
      |> tl
      |> Kernel.++([h])

    find_errors(t, pre_1, acc_1)
  end

  def gen_sums(ints) do
    for n <- ints, m <- ints do
      if n == m do
        []
      else
        n + m
      end
    end
    |> List.flatten()
  end
end

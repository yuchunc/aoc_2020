defmodule Day8 do
  @data File.read!("data/day8.txt")
        |> String.split("\n", trim: true)
        |> Enum.with_index()

  def task1 do
    run_ops(@data)
  end

  def task2 do
    find_terminate_value(@data)
  end

  defp find_terminate_value([{"acc" <> _, _} | t]) do
    find_terminate_value(t)
  end

  defp find_terminate_value([op_index | t]) do
    {<<op::bytes-size(3)>> <> " " <> shift_str, index} = op_index

    [op_1] = ["nop", "jmp"] -- [op]

    {val, looped} =
      @data
      |> List.replace_at(index, {"#{op_1} #{shift_str}", index})
      |> run_ops()

    if looped do
      find_terminate_value(t)
    else
      val
    end
  end

  defp run_ops(ops) do
    run_ops(hd(ops), [], 0, ops)
  end

  defp run_ops(nil, _, count, _), do: {count, false}

  defp run_ops(op_index, indices, count, ops) do
    {<<op::bytes-size(3)>> <> " " <> shift, index} = op_index

    if index in indices do
      {count, index in indices}
    else
      {next_op, indices_1, count_1} =
        process_op(op, String.to_integer(shift), index, count, indices, ops)

      run_ops(next_op, indices_1, count_1, ops)
    end
  end

  defp process_op("nop", _, index, count, indices, ops) do
    {Enum.at(ops, index + 1), [index | indices], count}
  end

  defp process_op("acc", shift, index, count, indices, ops) do
    {Enum.at(ops, index + 1), [index | indices], count + shift}
  end

  defp process_op("jmp", shift, index, count, indices, ops) do
    {Enum.at(ops, index + shift), [index | indices], count}
  end
end

defmodule Day4 do
  @data File.read!("data/day4.txt")
        |> String.trim()
        |> String.split("\n\n")

  @required_keys ["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid"]
  @valid_ecl ~w/amb blu brn gry grn hzl oth/

  def task1 do
    data()
    |> Enum.map(&Map.keys/1)
    |> Enum.filter(fn keys ->
      if @required_keys -- keys == [] do
        true
      else
        false
      end
    end)
    |> Enum.count()
  end

  def task2 do
    data()
    |> Enum.filter(&validate_passport/1)
    |> Enum.count()
  end

  defp data do
    @data
    |> Enum.map(&cast_data/1)
  end

  defp cast_data(datum) do
    Regex.split(~r/(\n|\s)/, datum)
    |> Enum.map(fn <<key::binary-size(3)>> <> ":" <> value ->
      {key, value}
    end)
    |> Enum.into(%{})
  end

  defp validate_passport(passport) do
    if @required_keys -- Map.keys(passport) == [] do
      passport
      |> Enum.map(&validate_field/1)
      |> Enum.reduce(&(&1 && &2))
    else
      false
    end
  end

  defp validate_field({"byr", <<byr::binary-size(4)>>}) do
    int = String.to_integer(byr)
    int >= 1920 && int <= 2002
  end

  defp validate_field({"iyr", <<iyr::binary-size(4)>>}) do
    int = String.to_integer(iyr)
    int >= 2010 && int <= 2020
  end

  defp validate_field({"eyr", <<eyr::binary-size(4)>>}) do
    int = String.to_integer(eyr)
    int >= 2020 && int <= 2030
  end

  defp validate_field({"hgt", hgt}) do
    [_, value, unit] = Regex.run(~r/(\d+)(\w+)/, hgt)
    int_val = String.to_integer(value)

    cond do
      unit == "cm" && int_val >= 150 && int_val <= 193 -> true
      unit == "in" && int_val >= 59 && int_val <= 76 -> true
      true -> false
    end
  end

  defp validate_field({"hcl", "#" <> <<hcl::binary-size(6)>>}) do
    Regex.match?(~r/[a-f0-9]{6}/, hcl)
  end

  defp validate_field({"ecl", ecl}) when ecl in @valid_ecl do
    true
  end

  defp validate_field({"pid", <<pid::binary-size(9)>>}) do
    Regex.match?(~r/\d{9}/, pid)
  end

  defp validate_field({"cid", _}), do: true

  defp validate_field(_), do: false
end

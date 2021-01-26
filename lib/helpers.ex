defmodule Helpers do
  @moduledoc false

  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")
  @min_length_word 2
  @mac_length_word 9
  @words_in_name 4

  def word(length \\ 5)
  def word(length) do
    1..length
    |> Enum.reduce([], fn _char, acc -> [Enum.random(@chars) | acc] end)
    |> Enum.join()
  end

  def words(qty) do
    1..qty
    |> Enum.map(fn _ ->
      random(@min_length_word, @mac_length_word) |> word()
    end)
  end

  def names(qty) do
    1..qty
    |> Enum.map(fn _ -> words(words_in_name()) end)
  end

  def random(min, max) when min < max, do: Enum.random(min..max)

  def words_in_name, do: @words_in_name
end

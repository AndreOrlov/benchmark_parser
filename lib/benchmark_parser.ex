defmodule BenchmarkParser do
  @moduledoc false

  @words Helpers.words(9)

  def words, do: @words

  def run do
    names = Helpers.names(10)
    random_names = random_qty_words_in_names(names)

    descriptions = random_insert_names(random_names, 20) |> IO.inspect(label: ANDRE_DESCRIPTIONS)

    Enum.map(descriptions, fn description ->
      rank =
        Enum.map(names, fn name ->
          find_name(description, name)
        end)

      {description, rank}
    end)
  end

  # private


  defp find_name(str, [f | iii] = name) do
    IO.inspect({{str, name}}, label: ANDRE_FIND_NAME)
    words = String.split(str, ~r/\s+/)
    case Enum.split_while(words, fn x -> x != f end) do
      {_, [_ | names]} ->
        names
        |> Enum.take(3)
        |> Enum.reduce(25, fn x, a ->
            if x in iii do
              a + 25
            else
              a
            end
        end)

      {_, []} ->
        0
    end
  end

  defp random_insert_names(random_names, qty) do
    1..qty
    |> Enum.map(fn _ ->
      @words
      |> IO.inspect(label: ANDRE_WORDS)
      |> Enum.split(2)
      |> Tuple.to_list()
      |> Enum.concat([Enum.random(random_names)])
      |> IO.inspect(label: ANDRE_WORDS_2)
      |> Enum.shuffle()
      |> IO.inspect(label: ANDRE_WORDS_3)
      |> List.flatten()
      |> Enum.join(" ")
      |> IO.inspect(label: ANDRE_WORDS_4)
    end)
  end

  defp random_qty_words_in_names(names) do
    names
    |> Enum.map(fn name ->
      qty =
        0..Helpers.words_in_name()
        |> Enum.random()

      name
      |> Enum.take(qty)
      |> Enum.shuffle()
    end)
  end

  # def deep_join([], str) do
  #   IO.inspect(label: ANDRE_D0)
  #  []
  # end
  def deep_join([head | tail], str) when is_list(head) do
    IO.inspect({head, tail}, label: ANDRE_D1)
    res = deep_join(head, str)
    res |> IO.inspect(label: ADDRE_D1_1)
    [res | deep_join(tail, str)]
  end
  def deep_join([head | tail] = list, str) when is_list(tail) do
    IO.inspect({head, tail}, label: ANDRE_D2)
    [Enum.join(list, str), deep_join(tail, str)]
  end
  def deep_join(list, str) do
    IO.inspect({list}, label: ANDRE_D3)
    [Enum.join(list, str)]
  end

  def flatten([]), do: []
  def flatten([head | tail]) when is_list(head) do
	  [flatten(flatten(head) ++ tail) |> Enum.join(" ")]
  end
  def flatten([head | tail]), do: [head | flatten(tail)]

  def t do
    [
      ["aaaa", "bbbb"],
      [
        ["FL", "AS"],
        ["QLMHAWTCI", "AOPDP"],
        ["SDBVWZ", "EADFROQ"]
      ]
  ]
  end
end

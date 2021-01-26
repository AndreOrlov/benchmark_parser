defmodule BenchmarkParser do
  @moduledoc false

  @words Helpers.words(9)
  @qty_names 1000
  @qty_descriptions 500

  def benchmark do
    Benchee.run(%{
      "simple_enumerate" => & run/0,
      "flow_enumerate"   => & run_flow/0
    })
  end

  def run do
    names = Helpers.names(@qty_names)
    random_names = random_qty_words_in_names(names)

    descriptions = random_insert_names(random_names, @qty_descriptions)

    Enum.map(descriptions, fn description ->
      rank =
        Enum.map(names, fn name ->
          find_name(description, name)
        end)

      {description, rank}
    end)
  end

  def run_flow do
    names = Helpers.names(@qty_names)
    random_names = random_qty_words_in_names(names)

    descriptions = random_insert_names(random_names, @qty_descriptions)

    descriptions
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(fn description ->
      rank =
        names
        |> Flow.from_enumerable()
        |> Flow.partition()
        |> Flow.map(fn name ->
          find_name(description, name)
        end)
        |> Enum.to_list()

      {description, rank}
    end)
    |> Enum.to_list()
  end

  # private

  defp find_name(str, [f | iii] = name) do
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
      |> Enum.split(2)
      |> Tuple.to_list()
      |> Enum.concat([Enum.random(random_names)])
      |> Enum.shuffle()
      |> List.flatten()
      |> Enum.join(" ")
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
end

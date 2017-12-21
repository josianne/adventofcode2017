defmodule Day01 do
  @moduledoc """
  Documentation for Day01.
  """

  @doc """
  Read in the supplied file and determine the sum of values followed by the same
  value.
  """
  def main(args \\ []) do
    args
    |> parse_args
    |> import_numbers
    |> sum_recurring
    |> IO.puts
  end

  @doc """
  Parses the args supplied to the program. Expects a file path to a file with a
  list of numbers
  """
  def parse_args(args) do
    {opts, _, _} = args
    |> OptionParser.parse(switches: [file: :string, part: :string], aliases: [f: :file, p: :part])

    opts
  end

  @doc """
  Expects a filepath containing a file that has a list of numbers
  """
  def import_numbers([file: filepath, part: part]) do
    case File.read(filepath) do
      {:ok, body} ->
        numbers = String.graphemes(body)
        |> Enum.map(fn(char) -> String.to_integer(char) end)

        offset = case part do
          "two" -> div(Enum.count(numbers), 2)
          _ -> 1
        end

        %{numbers: numbers, offset: offset}
      {:error, :enoent} ->
        IO.puts "Invalid filepath: #{filepath}"
        System.halt(0)
    end
  end

  @doc """
  Recursively sum the numbers if they're followed by the same number at an
  offset

  ## Examples

      iex> Day01.sum_recurring(%{numbers: [4, 4, 3, 2], offset: 1})
      4

      iex> Day01.sum_recurring(%{numbers: [4, 4, 3, 4], offset: 1})
      8

      iex> Day01.sum_recurring(%{numbers: [1, 2, 1, 2], offset: 2})
      6

      iex> Day01.sum_recurring(%{numbers: [1, 2, 1, 3, 1, 4, 1, 5], offset: 4})
      4
  """
  def sum_recurring(%{numbers: numbers, offset: offset}) do
    sum = fn({number, index}) ->
      next_index = Integer.mod(index + offset, Enum.count(numbers))

      if (number == Enum.fetch!(numbers, next_index)) do
        number
      else
        0
      end
    end

    numbers
    |> Enum.with_index
    |> Enum.map(sum)
    |> Enum.sum
  end
end

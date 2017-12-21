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
    |> OptionParser.parse(switches: [file: :string], aliases: [f: :file])

    opts
  end

  @doc """
  Expects a filepath containing a file that has a list of numbers
  """
  def import_numbers([file: filepath]) do
    case File.read(filepath) do
      {:ok, body} ->
        String.graphemes(body)
        |> Enum.map(fn(char) -> String.to_integer(char) end)
      {:error, :enoent} ->
        IO.puts "Invalid filepath: #{filepath}"
        System.halt(0)
    end
  end

  @doc """
  Recursively sum the numbers if they're followed by the same number in the list

  ## Examples

      iex> Day01.sum_recurring([4, 4, 3, 2])
      4

      iex> Day01.sum_recurring([4, 4, 3, 4])
      8
  """
  def sum_recurring(numbers) do
    sum = fn({number, index}) ->
      next_index = Integer.mod(index + 1, Enum.count(numbers))

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

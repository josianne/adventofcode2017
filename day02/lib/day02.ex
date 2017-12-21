defmodule Day02 do
  @moduledoc """
  Documentation for Day02.
  """

  @doc """
  Read in the supplied file and determine the checksum by summing the difference
  of the min and max in each row
  """
  def main(args \\ []) do
    args
    |> parse_args
    |> read_file
    |> import_numbers
    |> checksum
    |> IO.puts
  end

  @doc """
  Parses the args supplied to the program. Expects a file path to a file with a
  list of numbers and the part you're wanting to run
  """
  def parse_args(args) do
    {opts, _, _} = args
    |> OptionParser.parse(switches: [file: :string, part: :string], aliases: [f: :file, p: :part])

    opts
  end

  @doc """
  Expects a filepath containing a file that has a list of numbers in a grid
  """
  def read_file([file: filepath, part: _part]) do
    case File.read(filepath) do
      {:ok, body} ->
        body
      {:error, :enoent} ->
        IO.puts "Invalid filepath: #{filepath}"
        System.halt(0)
    end
  end


  @doc """
  Takes a string grid of numbers and turns it into a 2D array\

  ## Examples

      iex> Day02.import_numbers("1\t2\\n3\t4\\n5\t6")
      [[1, 2], [3, 4], [5, 6]]

  """
  def import_numbers(body) do
    parse_ints = fn(row) ->
      row
      |> String.split("\t")
      |> Enum.map(fn(char) -> String.to_integer(char) end)
    end

    body
    |> String.split("\n")
    |> Enum.map(parse_ints)
  end

  @doc """
  Generates the checksum by adding the difference between min and max of each
  array

  ## Examples

      iex> Day02.checksum([[5, 1, 9, 5], [7, 5, 3], [2, 4, 6, 8]])
      18
  """
  def checksum(numbers) do
    numbers
    |> Enum.map(fn(row) -> Day02.extent(row) end)
    |> Enum.sum
  end

  @doc """
  Gets the difference between the min and max values for a given array of numbers

  ## Examples

      iex> Day02.extent([5, 1, 9, 5])
      8

      iex> Day02.extent([7, 5, 3])
      4

      iex> Day02.extent([2, 4, 6, 8])
      6
  """
  def extent(numbers) do
    {min, max} = Enum.min_max(numbers)

    max - min
  end
end

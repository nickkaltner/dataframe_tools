defmodule DataframeTools.Date do
  @doc ~S"""
  Automagically try and convert a column in a dataframe to a date or datetime.
  It will check to see if the first 10 items in that column are dates,
  based on zero padding eg. 2021-01-01 yyyy-mm-dd
  and if so, convert to a date.  If not, convert to a datetime.

  TODO: look at converting numbers in a reasonable timestamp range to datetimes

  ## Examples

      iex> df = Explorer.DataFrame.new(%{
      ...>   dates: Explorer.Series.from_list(~w(2010-01-01 2020-02-01)),
      ...>   datetimes: Explorer.Series.from_list([1, nil])
      ...> })
      iex> df2 = DataframeTools.Date.convert_column_to_date(df, :dates)
      iex> Explorer.DataFrame.dtypes(df2)
      %{"dates" => :date, "datetimes" => {:s, 64}}


      iex> df = Explorer.DataFrame.new(%{
      ...>   dates: Explorer.Series.from_list(~w(2010-01-01 2020-02-01)),
      ...>   datetimes: Explorer.Series.from_list(["2024-04-25T13:05:41+10:00", "2024-04-01T13:05:41+10:00"])
      ...> })
      iex> df3 = DataframeTools.Date.convert_column_to_date(df, :datetimes)
      iex> Explorer.DataFrame.dtypes(df3)
      %{"dates" => :string, "datetimes" => {:datetime, :microsecond}}


  """
  def convert_column_to_date(df, column_name)
      when is_binary(column_name) or is_atom(column_name) do
    dtype = Explorer.DataFrame.dtypes(df) |> Map.get("#{column_name}")
    sample_data = get_sample(df, column_name)

    is_date =
      sample_data
      |> Enum.all?(fn x ->
        case Date.from_iso8601(x) do
          {:ok, _} -> true
          _ -> false
        end
      end)

    case dtype do
      :string ->
        df
        |> Explorer.DataFrame.mutate_with(fn inner_df ->
          # https://hexdocs.pm/explorer/Explorer.Series.html#strptime/2
          #
          cond do
            is_date ->
              %{
                column_name =>
                  Explorer.Series.cast(
                    Explorer.Series.strptime(inner_df[column_name], "%Y-%m-%d"),
                    :date
                  )
              }

            true ->
              %{column_name => Explorer.Series.strptime(inner_df[column_name], "%+")}
          end

          #
        end)

      any ->
        throw("invalid conversion between #{inspect(any)} and date")
    end
  end

  defp get_sample(df, column_name) do
    Explorer.Series.slice(df[column_name], 0, 10)
    |> Explorer.Series.to_enum()
    |> Enum.into([])
  end

  # def filter_on_date(df, column, from_date \\ nil, to_date \\ nil) do
  # end
end

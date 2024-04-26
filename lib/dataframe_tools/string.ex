require Explorer.DataFrame, as: DF

defmodule DataframeTools.String do
  @doc ~S"""
  Converts all string columns in a DataFrame to categories where n_unique items < half total items.
  This is just a way to make more efficient use of memory and faster joins.

  ## Examples

      iex> df = Explorer.DataFrame.new(%{
      ...>   names: Explorer.Series.from_list(~w(bob bob bob harry tom tom harry bob bob bob)),
      ...>   unique_names: Explorer.Series.from_list(~w(a bcob c d e f g h i j))
      ...> })
      iex> df2 = DataframeTools.String.categorise_columns(df)
      iex> Explorer.DataFrame.dtypes(df2)
      %{"names" => :category, "unique_names" => :string}

  """
  def categorise_columns(df) do
    string_columns =
      DF.dtypes(df)
      |> Enum.filter(fn {_, v} -> v == :string end)
      |> Enum.map(fn {k, _} -> k end)

    transforms =
      Enum.map(string_columns, fn col_name ->
        total = Explorer.Series.count(df[col_name])
        unique = Explorer.Series.n_distinct(df[col_name])

        if unique < total / 2 do
          {col_name, Explorer.Series.cast(df[col_name], :category)}
        else
          nil
        end
      end)
      |> Enum.filter(fn x -> !is_nil(x) end)

    DF.mutate(df, ^transforms)
  end
end

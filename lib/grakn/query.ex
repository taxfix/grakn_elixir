defmodule Grakn.Query do

  @type t :: %__MODULE__{graql: String.t()}

  defstruct [:graql]
  def graql(graql_query), do: %__MODULE__{graql: graql_query}
end

defimpl DBConnection.Query, for: Grakn.Query do
  def parse(query, _opts) when is_binary(query) do
    %Grakn.Query{graql: query}
  end

  def parse(query, _opts), do: query
  def describe(query, _opts), do: query
  def encode(_query, params, _opts), do: params
  def decode(_query, result, _opts), do: result
end

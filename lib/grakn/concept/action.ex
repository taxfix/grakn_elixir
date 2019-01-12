defmodule Grakn.Concept.Action do
  @moduledoc """
  `ConceptAction` should only be used internally by grakn_elixir to fetch
  concept information laizily.

  Sub modules in `Grakn.Concept` should be the only place where these requests are used
  """

  @type action :: :attribute_value
  @type t :: %__MODULE__{action: action()}

  defstruct [:action]

  @spec new(action()) :: t()
  def new(action), do: struct(__MODULE__, action: action)

  def attribute_value, do: new(:attribute_value)
end

defimpl DBConnection.Query, for: Grakn.Concept.Action do
  def parse(query, _opts), do: query
  def describe(query, _opts), do: query
  def encode(_query, params, _opts), do: params
  def decode(_query, result, _opts), do: result
end

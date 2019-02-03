defmodule Grakn.Concept.Action do
  @moduledoc """
  `ConceptAction` should only be used internally by grakn_elixir to fetch
  concept information lazily.

  Sub modules in `Grakn.Concept` should be the only place where these requests are used
  """

  @type name ::
          :attribute_value
          | :attributes_by_type
          | :get_schema_concept
          | :get_attribute_types
          | :concept_label
  @type t :: %__MODULE__{name: name()}

  defstruct [:name]

  @spec new(name()) :: t()
  def new(name), do: struct(__MODULE__, name: name)

  def attribute_value, do: new(:attribute_value)
  def attributes_by_type, do: new(:attributes_by_type)
  def get_schema_concept, do: new(:get_schema_concept)
  def get_attribute_types, do: new(:get_attribute_types)
  def concept_label, do: new(:concept_label)
end

defimpl DBConnection.Query, for: Grakn.Concept.Action do
  def parse(query, _opts), do: query
  def describe(query, _opts), do: query
  def encode(_query, params, _opts), do: params
  def decode(_query, result, _opts), do: result
end

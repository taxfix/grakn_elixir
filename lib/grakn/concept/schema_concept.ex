defmodule Grakn.Concept.SchemaConcept do
  alias Grakn.Concept
  alias Concept.Action

  @spec get(String.t(), DBConnection.t(), keyword()) :: {:ok, Concept.t()} | {:error, any()}
  def get(label, conn, opts \\ []) do
    DBConnection.execute(conn, Action.get_schema_concept(), [label], opts)
  end

  @spec get(Concept.t(), DBConnection.t(), keyword()) :: {:ok, Stirng.t()} | {:error, any()}
  def label(%{id: concept_id}, conn, opts \\ []) do
    DBConnection.execute(conn, Action.concept_label(), [concept_id], opts)
  end

  @spec get(Concept.t(), DBConnection.t(), keyword()) :: {:ok, [Concept.t()]} | {:error, any()}
  def attribute_types(%{id: concept_id}, conn, opts \\ []) do
    DBConnection.execute(conn, Action.get_attribute_types(), [concept_id], opts)
  end
end

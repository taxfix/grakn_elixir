defmodule Grakn.Concept.SchemaConcept do
  @moduledoc """
  Concept methods for `SchemaConcepts`
  """

  alias Grakn.Concept
  alias Concept.Action

  @spec get(String.t(), DBConnection.t(), keyword()) :: {:ok, Concept.t()} | {:error, any()}
  def get(label, conn, opts \\ []) do
    DBConnection.execute(conn, Action.get_schema_concept(), [label], opts)
    |> case do
      {:ok, _query, result} ->
        {:ok, result}

      otherwise ->
        otherwise
    end
  end

  @spec label(Concept.t(), DBConnection.t(), keyword()) :: {:ok, String.t()} | {:error, any()}
  def label(%{id: concept_id}, conn, opts \\ []) do
    DBConnection.execute(conn, Action.concept_label(), [concept_id], opts)
    |> case do
      {:ok, _query, result} ->
        {:ok, result}

      otherwise ->
        otherwise
    end
  end

  @spec attribute_types(Concept.t(), DBConnection.t(), keyword()) ::
          {:ok, [Concept.t()]} | {:error, any()}
  def attribute_types(%{id: concept_id}, conn, opts \\ []) do
    DBConnection.execute(conn, Action.get_attribute_types(), [concept_id], opts)
    |> case do
      {:ok, _query, result} ->
        {:ok, result}

      otherwise ->
        otherwise
    end
  end
end

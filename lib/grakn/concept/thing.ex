defmodule Grakn.Concept.Thing do
  @moduledoc """
  Common concept methods for all instances (`Things`)
  """

  alias Grakn.Concept
  alias Concept.Action

  @doc """
  Get all attributes of the specified types associated with this instance
  """
  @spec get_attributes(Concept.t(), [String.t()], DBConnection.t()) ::
          {:ok, any()} | {:error, any()}
  def get_attributes(%{id: concept_id} = concept, attribute_types, conn, opts \\ []) do
    with :ok <- assert_is_thing(concept) do
      DBConnection.execute(conn, Action.attributes_by_type(), [concept_id, attribute_types], opts)
      |> case do
        {:ok, _query, result} ->
          {:ok, result}

        otherwise ->
          otherwise
      end
    end
  end

  defp assert_is_thing(concept) do
    if Concept.is_thing(concept) do
      :ok
    else
      {:error, "#{inspect(concept)} is not an instance"}
    end
  end
end

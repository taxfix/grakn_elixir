defmodule Grakn.Concept.Attribute do
  alias Grakn.Concept
  alias Grakn.Concept.Action

  @doc """
  Get the value of the specified attribute concept using the given connection
  """
  @spec value(Concept.t(), DBConnection.t()) :: {:ok, any()} | {:error, any()}
  def value(%{id: concept_id} = concept, conn, opts \\ []) do
    with :ok <- assert_is_attribute(concept) do
      DBConnection.execute(conn, Action.attribute_value(), [concept_id], opts)
    end
  end

  defp assert_is_attribute(concept) do
    if Concept.is_attribute(concept) do
      :ok
    else
      {:error, "#{inspect(concept)} is not an attribute"}
    end
  end
end

defmodule Grakn.Concept.Entity do
  @moduledoc """
  Concept methods for Entities
  """

  defdelegate get_attributes(concept, attribute_types, conn, opts \\ []), to: Grakn.Concept.Thing
end

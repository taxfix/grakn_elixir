defmodule Grakn.Concept.Relationship do
  @moduledoc """
  Concept methods for Relationships
  """

  defdelegate get_attributes(concept, attribute_types, conn, opts \\ []), to: Grakn.Concept.Thing
end

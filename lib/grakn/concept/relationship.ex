defmodule Grakn.Concept.Relationship do
  defdelegate get_attributes(concept, attribute_types, conn, opts \\ []), to: Grakn.Concept.Thing
end

defmodule Grakn.Concept.Entity do
  defdelegate get_attributes(concept, attribute_types, conn, opts \\ []), to: Grakn.Concept.Thing
end

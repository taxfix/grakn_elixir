defmodule Grakn.Concept do
  @moduledoc false
  
  @type t :: Session.Concept.t()

  @meta_type 0
  @entity_type 1
  @relationship_type 2
  @attribute_type 3
  @role 4
  @rule 5
  @entity 6
  @relationship 7
  @attribute 8

  @types [@attribute_type, @relationship_type, @entity_type]
  @things [@attribute, @relationship, @entity]
  @schema_concepts [@rule, @role, @attribute_type, @relationship_type, @entity_type]

  @spec is_type(t()) :: boolean()
  def is_type(%{baseType: base_type}) when base_type in @types, do: true
  def is_type(_), do: false

  @spec is_thing(t()) :: boolean()
  def is_thing(%{baseType: base_type}) when base_type in @things, do: true
  def is_thing(_), do: false

  @spec is_entity_type(t()) :: boolean()
  def is_entity_type(%{baseType: @entity_type}), do: true
  def is_entity_type(_), do: false

  @spec is_attribute_type(t()) :: boolean()
  def is_attribute_type(%{baseType: @attribute_type}), do: true
  def is_attribute_type(_), do: false

  @spec is_relationship_type(t()) :: boolean()
  def is_relationship_type(%{baseType: @relationship_type}), do: true
  def is_relationship_type(_), do: false

  @spec is_entity(t()) :: boolean()
  def is_entity(%{baseType: @entity}), do: true
  def is_entity(_), do: false

  @spec is_attribute(t()) :: boolean()
  def is_attribute(%{baseType: @attribute}), do: true
  def is_attribute(_), do: false

  @spec is_relationship(t()) :: boolean()
  def is_relationship(%{baseType: @attribute}), do: true
  def is_relationship(_), do: false

  @spec is_schema(t()) :: boolean()
  def is_schema(%{baseType: base_type}) when base_type in @schema_concepts, do: true
  def is_schema(_), do: false

  @spec is_meta_type(t()) :: boolean()
  def is_meta_type(%{baseType: @meta_type}), do: true
  def is_meta_type(_), do: false
end

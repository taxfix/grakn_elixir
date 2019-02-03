defmodule Grakn.Concept.ThingTest do
  use ExUnit.Case

  alias Grakn.{
    Query,
    Command,
    Concept
  }

  @keyspace "grakn_elixir_concept_thing_test"

  setup_all do
    Grakn.TestHelper.init_test_keyspace(@keyspace)
  end

  describe "attributes/4" do
    test "fetch existing attribute", context do
      assert {:ok, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   Grakn.query!(
                     conn,
                     Query.graql(
                       "insert $p isa person, has identifier \"123\", has name \"alex\";"
                     )
                   )
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert {:ok, [%{"p" => person}]} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   conn
                   |> Grakn.query!(
                     Query.graql("match $p isa person, has identifier \"123\"; get;")
                   )
                   |> Enum.to_list()
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert {:ok, name} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   with {:ok, name_attribute} <- Concept.SchemaConcept.get("name", conn),
                        {:ok, stream} <-
                          Concept.Thing.get_attributes(person, [name_attribute], conn),
                        [attribute_instance] <- Enum.to_list(stream),
                        {:ok, value} <- Concept.Attribute.value(attribute_instance, conn) do
                     value
                   end
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert "alex" === name
    end
  end
end

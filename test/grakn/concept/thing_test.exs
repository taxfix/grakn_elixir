defmodule Grakn.Concept.ThingTest do
  use ExUnit.Case

  alias Grakn.{Query, Concept}

  @keyspace "grakn_elixir_concept_thing_test"

  setup_all do
    TestHelper.init_test_keyspace(@keyspace)
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

  describe "is_inferred?/3" do
    test "we can detect inferred atttributes", context do
      assert {:ok, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   Grakn.query!(
                     conn,
                     Query.graql(
                       "insert $p isa person, has identifier \"1234\", has name \"alex\";"
                     )
                   )
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert {:ok, true} ===
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   [%{"is_named" => is_named}] =
                     Grakn.query!(
                       conn,
                       Query.graql(
                         "match $p isa person, has identifier \"1234\"; $p has is_named $is_named; get;"
                       ),
                       include_inferences: true
                     )

                   {:ok, value} = Concept.Thing.is_inferred?(is_named, conn)
                   value
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )
    end
  end
end

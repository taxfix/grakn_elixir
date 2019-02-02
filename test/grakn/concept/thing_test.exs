defmodule Grakn.Concept.ThingTest do
  use ExUnit.Case

  alias Grakn.{
    Query,
    Command,
    Concept
  }

  @keyspace "grakn_elixir_concept_thing_test"

  setup_all do
    {:ok, conn} = Grakn.start_link(hostname: "localhost")
    conn |> Grakn.command(Command.delete_keyspace(@keyspace))

    conn
    |> Grakn.transaction(
      fn conn ->
        Grakn.query!(conn, Query.graql("define name sub attribute datatype string;"))
        Grakn.query!(conn, Query.graql("define identifier sub attribute datatype string;"))
        Grakn.query!(conn, Query.graql("define person sub entity, has name, has identifier;"))
      end,
      keyspace: @keyspace,
      type: Grakn.Transaction.Type.write()
    )

    {:ok, conn: conn}
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
                   Grakn.query!(
                     conn,
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

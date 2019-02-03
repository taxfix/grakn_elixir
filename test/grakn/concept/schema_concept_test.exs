defmodule Grakn.Concept.SchemaConceptTest do
  use ExUnit.Case

  alias Grakn.{
    Query,
    Command,
    Concept
  }

  @keyspace "grakn_elixir_concept_schema_test"

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

  describe "attribute_types/3" do
    test "fetch existing attribute", context do
      assert {:ok, attributes} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   with {:ok, type} <- Concept.SchemaConcept.get("person", conn),
                        {:ok, attributes} <- Concept.SchemaConcept.attribute_types(type, conn) do
                     attributes
                     |> Enum.map(fn att ->
                       with {:ok, label} <- Concept.SchemaConcept.label(att, conn), do: label
                     end)
                     |> Enum.to_list()
                   end
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert ["name", "identifier"] === attributes
    end
  end

  describe "labe/3" do
    test "fetch label", context do
      assert {:ok, label} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   with {:ok, type} <- Concept.SchemaConcept.get("person", conn),
                        {:ok, label} <- Concept.SchemaConcept.label(type, conn) do
                     label
                   end
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert "person" === label
    end
  end
end

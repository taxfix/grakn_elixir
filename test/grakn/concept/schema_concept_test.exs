defmodule Grakn.Concept.SchemaConceptTest do
  use ExUnit.Case

  alias Grakn.Concept.SchemaConcept

  @keyspace "grakn_elixir_concept_schema_test"

  setup_all do
    TestHelper.init_test_keyspace(@keyspace)
  end

  describe "attribute_types/3" do
    test "fetch existing attribute", context do
      assert {:ok, attributes} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   with {:ok, type} <- SchemaConcept.get("person", conn),
                        {:ok, attributes} <- SchemaConcept.attribute_types(type, conn) do
                     attributes
                     |> Enum.map(fn att ->
                       with {:ok, label} <- SchemaConcept.label(att, conn), do: label
                     end)
                     |> Enum.to_list()
                   end
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert Enum.sort(attributes) == Enum.sort(["name", "identifier"])
    end
  end

  describe "labe/3" do
    test "fetch label", context do
      assert {:ok, label} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   with {:ok, type} <- SchemaConcept.get("person", conn),
                        {:ok, label} <- SchemaConcept.label(type, conn) do
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

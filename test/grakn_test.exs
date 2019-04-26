defmodule GraknTest do
  use ExUnit.Case
  doctest Grakn

  @keyspace "grakn_elixir_test"

  setup do
    {:ok, conn} = Grakn.start_link(hostname: "localhost")
    conn |> Grakn.command(Grakn.Command.delete_keyspace(@keyspace))

    Grakn.transaction(
      conn,
      fn conn ->
        Grakn.query!(conn, Grakn.Query.graql("define person sub entity;"))
        Grakn.query!(conn, Grakn.Query.graql("insert $x isa person;"))
      end,
      keyspace: @keyspace,
      type: Grakn.Transaction.Type.write()
    )

    {:ok, conn: conn}
  end

  describe "query" do
    test "returns a non-empty concept iterator", context do
      assert {:ok, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   {:ok, iterator} =
                     Grakn.query(conn, Grakn.Query.graql("match $x isa thing; get;"))

                   assert not Enum.empty?(iterator)
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )
    end

    test "multiple inserts", context do
      assert {:ok, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   Grakn.query!(
                     conn,
                     Grakn.Query.graql("define name sub attribute, datatype string;")
                   )

                   Grakn.query!(
                     conn,
                     Grakn.Query.graql("define age sub attribute, datatype long;")
                   )

                   Grakn.query!(
                     conn,
                     Grakn.Query.graql("define person sub entity, has name, has age;")
                   )
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert {:ok, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   Grakn.query(conn, Grakn.Query.graql("insert $x isa person;"))
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert {:ok, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   Grakn.query!(
                     conn,
                     Grakn.Query.graql("match $x isa person; insert $x has name \"test\";")
                   )

                   Grakn.query!(
                     conn,
                     Grakn.Query.graql("match $x isa person; insert $x has age 100;")
                   )
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )
    end

    test "incorrect schema", context do
      assert {:ok, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   Grakn.query!(
                     conn,
                     Grakn.Query.graql("define name sub attribute, datatype string;")
                   )

                   Grakn.query!(conn, Grakn.Query.graql("define city sub entity, has name;"))
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert {:error, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   {:error, reason} =
                     Grakn.query(
                       conn,
                       Grakn.Query.graql("insert $x isa city; $x has city_name \"wrong\";")
                     )

                   Grakn.rollback(conn, reason)
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )
    end

    test "check result", context do
      insert_person = fn conn ->
        Grakn.query!(conn, Grakn.Query.graql("insert $x isa person;"))
      end

      assert {:ok, [%{"x" => %{id: _}}]} =
               Grakn.transaction(context[:conn], insert_person,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )
    end
  end

  describe "concept maps" do
    test "get attribute value in different transaction", context do
      assert {:ok, color_vars} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   Grakn.query!(
                     conn,
                     Grakn.Query.graql("define color sub attribute, datatype string;")
                   )

                   Grakn.query!(conn, Grakn.Query.graql("define car sub entity, has color;"))
                   Grakn.query!(conn, Grakn.Query.graql("insert $c isa car, has color \"red\";"))

                   conn
                   |> Grakn.query!(
                     Grakn.Query.graql("match $c isa car, has color $color; get $color;")
                   )
                   |> Enum.to_list()
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert {:ok, colors} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   color_vars
                   |> Enum.map(fn %{"color" => attribute} ->
                     with {:ok, color} <- Grakn.Concept.Attribute.value(attribute, conn),
                          do: color
                   end)
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert colors === ["red"]
    end
  end

  describe "data definition language" do
    test "we can declare an attribute", context do
      assert {:ok, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   {:ok, iterator} =
                     Grakn.query(
                       conn,
                       Grakn.Query.graql("define name sub attribute, datatype string;")
                     )

                   assert not Enum.empty?(iterator)
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )
    end
  end

  describe "commands" do
    test "get all keyspaces should contain a the previously initialized keyspace", context do
      Grakn.command(context[:conn], Grakn.Command.create_keyspace(@keyspace))

      assert {:ok, _} =
               Grakn.transaction(
                 context[:conn],
                 fn conn ->
                   {:ok, iterator} =
                     Grakn.query(conn, Grakn.Query.graql("match $x isa thing; get;"))

                   assert not Enum.empty?(iterator)
                 end,
                 keyspace: @keyspace,
                 type: Grakn.Transaction.Type.write()
               )

      assert {:ok, names} = Grakn.command(context[:conn], Grakn.Command.get_keyspaces())
      assert Enum.member?(names, @keyspace)
    end

    # Create namespace returns an error from server. It seems to be a issue in the
    # GRPC API. However, the delete command works as expected.
    # Skipping this test for now until issue is resolved.
    @tag :skip
    test "create and delete keyspaces", context do
      keyspace = Integer.to_string(:rand.uniform(10_000), 16)
      assert {:ok, nil} = Grakn.command(context[:conn], Grakn.Command.create_keyspace(keyspace))
      assert {:ok, names} = Grakn.command(context[:conn], Grakn.Command.get_keyspaces())
      assert Enum.member?(names, keyspace)
      assert {:ok, nil} = Grakn.command(context[:conn], Grakn.Command.delete_keyspace(keyspace))
      assert {:ok, names} = Grakn.command(context[:conn], Grakn.Command.get_keyspaces())
      assert not Enum.member?(names, keyspace)
    end
  end
end

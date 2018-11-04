defmodule GraknTest do
  use ExUnit.Case
  doctest Grakn

  setup do
    {:ok, conn} = Grakn.start_link hostname: "localhost"
    {:ok, conn: conn}
  end

  describe "query" do

    test "returs a non-empty concept iterator", context do
      Grakn.transaction(context[:conn], fn conn ->
        {:ok, iterator} = Grakn.query(conn, Grakn.Query.graql("match $x; get;"))
        assert not Enum.empty?(iterator)
      end)
    end

    test "multiple inserts", context do
      {:ok, _} = Grakn.transaction(context[:conn], fn conn ->
        Grakn.query!(conn, Grakn.Query.graql("define name sub attribute, datatype string;"))
        Grakn.query!(conn, Grakn.Query.graql("define age sub attribute, datatype long;"))
        Grakn.query!(conn, Grakn.Query.graql("define person sub entity, has name, has age;"))
      end, type: Grakn.Transaction.Type.write())
      {:ok, _} = Grakn.transaction(context[:conn], fn conn ->
        Grakn.query(conn, Grakn.Query.graql("insert $x isa person;"))
      end, type: Grakn.Transaction.Type.write())
      {:ok, _} = Grakn.transaction(context[:conn], fn conn ->
        Grakn.query!(conn, Grakn.Query.graql("match $x isa person; insert $x has name \"test\";"))
        Grakn.query!(conn, Grakn.Query.graql("match $x isa person; insert $x has age 100;"))
      end, type: Grakn.Transaction.Type.write())
    end

    test "incorrect schema", context do
      {:ok, _} = Grakn.transaction(context[:conn], fn conn ->
        Grakn.query!(conn, Grakn.Query.graql("define name sub attribute, datatype string;"))
        Grakn.query!(conn, Grakn.Query.graql("define city sub entity, has name;"))
      end, type: Grakn.Transaction.Type.write())
      {:error, _} = Grakn.transaction(context[:conn], fn conn ->
        {:error, reason} = Grakn.query(conn, Grakn.Query.graql("insert $x isa city; $x has city_name \"wrong\";"))
        Grakn.rollback(conn, reason)
      end, type: Grakn.Transaction.Type.write())
    end

  end

  describe "data definition language" do

    test "we can declare an attribute", context do
      Grakn.transaction(
        context[:conn],
        fn conn ->
          {:ok, iterator} = Grakn.query(conn, Grakn.Query.graql("define name sub attribute, datatype string;"))
          assert not Enum.empty?(iterator)
        end,
        [ type: Grakn.Transaction.Type.write() ]
      )
    end

  end

  describe "commands" do
    test "get all keyspaces should contain the default grakn keyspace", context do
      {:ok, names} = Grakn.command(context[:conn], Grakn.Command.get_keyspaces())
      assert Enum.member?(names, "grakn")
    end

    # Create namespace returns an error from server. It seems to be a issue in the
    # GRPC API. However, the delete command works as expected.
    # Skipping this test for now until issue is resolved.
    @tag :skip
    test "create and delete keyspaces", context do
      keyspace = Integer.to_string(:rand.uniform(10000), 16)
      {:ok, nil} = Grakn.command(context[:conn], Grakn.Command.create_keyspace(keyspace))
      {:ok, names} = Grakn.command(context[:conn], Grakn.Command.get_keyspaces())
      assert Enum.member?(names, keyspace)
      {:ok, nil} = Grakn.command(context[:conn], Grakn.Command.delete_keyspace(keyspace))
      {:ok, names} = Grakn.command(context[:conn], Grakn.Command.get_keyspaces())
      assert not Enum.member?(names, keyspace)
    end

  end
end

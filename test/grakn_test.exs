defmodule GraknTest do
  use ExUnit.Case
  doctest Grakn

  @keyspace "grakn_elixir_test"

  setup do
    {:ok, conn} = Grakn.start_link(hostname: "localhost")
    conn |> Grakn.command(Grakn.Command.delete_keyspace(@keyspace))
    {:ok, conn: conn}
  end

  describe "query" do
    test "returs a non-empty concept iterator", context do
      Grakn.transaction(
        context[:conn],
        fn conn ->
          {:ok, iterator} = Grakn.query(conn, Grakn.Query.graql("match $x; get;"))

          assert not Enum.empty?(iterator)
        end,
        keyspace: @keyspace
      )
    end

    test "multiple inserts", context do
      {:ok, _} =
        Grakn.transaction(
          context[:conn],
          fn conn ->
            Grakn.query!(conn, Grakn.Query.graql("define name sub attribute, datatype string;"))
            Grakn.query!(conn, Grakn.Query.graql("define age sub attribute, datatype long;"))
            Grakn.query!(conn, Grakn.Query.graql("define person sub entity, has name, has age;"))
          end,
          keyspace: @keyspace,
          type: Grakn.Transaction.Type.write()
        )

      {:ok, _} =
        Grakn.transaction(
          context[:conn],
          fn conn ->
            Grakn.query(conn, Grakn.Query.graql("insert $x isa person;"))
          end,
          keyspace: @keyspace,
          type: Grakn.Transaction.Type.write()
        )

      {:ok, _} =
        Grakn.transaction(
          context[:conn],
          fn conn ->
            Grakn.query!(
              conn,
              Grakn.Query.graql("match $x isa person; insert $x has name \"test\";")
            )

            Grakn.query!(conn, Grakn.Query.graql("match $x isa person; insert $x has age 100;"))
          end,
          keyspace: @keyspace,
          type: Grakn.Transaction.Type.write()
        )
    end

    test "incorrect schema", context do
      {:ok, _} =
        Grakn.transaction(
          context[:conn],
          fn conn ->
            Grakn.query!(conn, Grakn.Query.graql("define name sub attribute, datatype string;"))
            Grakn.query!(conn, Grakn.Query.graql("define city sub entity, has name;"))
          end,
          keyspace: @keyspace,
          type: Grakn.Transaction.Type.write()
        )

      {:error, _} =
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
  end

  describe "concept maps" do
    test "get attribute value in different transaction", context do
      {:ok, color_vars} =
        Grakn.transaction(
          context[:conn],
          fn conn ->
            Grakn.query!(conn, Grakn.Query.graql("define color sub attribute datatype string;"))
            Grakn.query!(conn, Grakn.Query.graql("define car sub entity, has color;"))
            Grakn.query!(conn, Grakn.Query.graql("insert $c isa car, has color \"red\";"))

            Grakn.query!(
              conn,
              Grakn.Query.graql("match $c isa car, has color $color; get $color;")
            )
            |> Enum.to_list()
          end,
          keyspace: @keyspace,
          type: Grakn.Transaction.Type.write()
        )

      {:ok, colors} =
        Grakn.transaction(
          context[:conn],
          fn conn ->
            color_vars
            |> Enum.map(fn %{"color" => attribute} ->
              with {:ok, color} <- Grakn.Concept.Attribute.value(attribute, conn), do: color
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
      Grakn.transaction(
        context[:conn],
        fn conn ->
          {:ok, iterator} =
            Grakn.query(conn, Grakn.Query.graql("define name sub attribute, datatype string;"))

          assert not Enum.empty?(iterator)
        end,
        keyspace: @keyspace,
        type: Grakn.Transaction.Type.write()
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
      keyspace = Integer.to_string(:rand.uniform(10_000), 16)
      {:ok, nil} = Grakn.command(context[:conn], Grakn.Command.create_keyspace(keyspace))
      {:ok, names} = Grakn.command(context[:conn], Grakn.Command.get_keyspaces())
      assert Enum.member?(names, keyspace)
      {:ok, nil} = Grakn.command(context[:conn], Grakn.Command.delete_keyspace(keyspace))
      {:ok, names} = Grakn.command(context[:conn], Grakn.Command.get_keyspaces())
      assert not Enum.member?(names, keyspace)
    end
  end
end

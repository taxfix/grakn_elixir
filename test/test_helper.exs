ExUnit.start(exclude: [:skip])

defmodule TestHelper do
  alias Grakn.{Command, Query}

  def exit_test(message) do
    IO.puts(message)
    System.halt(1)
  end

  def extract_grakn_status(output) do
    output
    |> String.split("\n")
    |> Enum.at(-2)
    |> String.split(":")
    |> Enum.at(1)
    |> String.trim()
  end

  def init_test_keyspace(keyspace) do
    {:ok, conn} = Grakn.start_link()
    Grakn.command(conn, Command.delete_keyspace(keyspace))

    Grakn.transaction(conn, &define_base_schema/1,
      keyspace: keyspace,
      type: Grakn.Transaction.Type.write()
    )

    {:ok, conn: conn}
  end

  defp define_base_schema(conn) do
    Grakn.query!(conn, Query.graql("define name sub attribute, datatype string;"))
    Grakn.query!(conn, Query.graql("define is_named sub attribute, datatype boolean;"))
    Grakn.query!(conn, Query.graql("define identifier sub attribute, datatype string;"))

    Grakn.query!(
      conn,
      Query.graql("define person sub entity, has name, has is_named, has identifier;")
    )

    Grakn.query!(
      conn,
      Query.graql(
        "define r1 sub rule, when { $p isa person; $p has name $name; }, then { $p has is_named true; };"
      )
    )
  end
end

if System.get_env("GRAKN_LOCAL") do
  {output, status} = System.cmd("grakn", ["server", "status"])

  cond do
    status != 0 ->
      TestHelper.exit_test("Unable to execute 'grakn' command. Make sure Grakn is installed")

    TestHelper.extract_grakn_status(output) === "RUNNING" ->
      :running

    true ->
      System.cmd("grakn", ["server", "start"])
  end
end

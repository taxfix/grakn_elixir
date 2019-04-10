defmodule Grakn.TestHelper do
  @moduledoc false

  def init_test_keyspace(keyspace) do
    {:ok, conn} = Grakn.start_link(hostname: "localhost")
    conn |> Grakn.command(Command.delete_keyspace(@keyspace))

    conn
    |> Grakn.transaction(
      fn conn ->
        Grakn.query!(conn, Query.graql("define name sub attribute datatype string;"))
        Grakn.query!(conn, Query.graql("define identifier sub attribute datatype string;"))
        Grakn.query!(conn, Query.graql("define person sub entity, has name, has identifier;"))
      end,
      keyspace: keyspace,
      type: Grakn.Transaction.Type.write()
    )

    {:ok, conn: conn}
  end
end

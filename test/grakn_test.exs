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
end

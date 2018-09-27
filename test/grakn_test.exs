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
end

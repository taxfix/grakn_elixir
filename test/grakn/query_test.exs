defmodule Grakn.QueryTest do
  use ExUnit.Case
  doctest Grakn.Query

  test "create new Query from graql string" do
    graql = "test query"
    query = Grakn.Query.graql(graql)
    assert query.graql == graql
  end
end

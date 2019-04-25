defmodule Grakn.GraqlTest do
  use ExUnit.Case
  use Grakn.Graql

  test "define an attribute" do
    %{graql: graql} = defschema("att", sub: :attribute)
    assert graql === "define att sub attribute;"
  end

  test "define an attribute with datatype" do
    %{graql: graql} = defschema("att", sub: :attribute, datatype: datatypes().string)
    assert graql === "define att sub attribute, datatype string;"
  end

  test "define an entity" do
    %{graql: graql} = defschema("something", sub: :entity)
    assert graql === "define something sub entity;"
  end

  test "define an entity with attribute" do
    %{graql: graql} =
      defschema("something",
        sub: :entity,
        has: "att"
      )

    assert graql === "define something sub entity, has att;"
  end

  test "define an entity with multiple attributes" do
    %{graql: graql} =
      defschema("something",
        sub: :entity,
        has: ["att1", "att2"]
      )

    assert graql === "define something sub entity, has att1, has att2;"
  end

  test "define a relation" do
    %{graql: graql} = defschema("r", sub: :relation, relates: ["x", "y"])
    assert graql === "define r sub relation, relates x, relates y;"
  end

  test "define a relation with attribute" do
    %{graql: graql} =
      defschema("r",
        sub: :relation,
        relates: ["x", "y"],
        has: "att1"
      )

    assert graql === "define r sub relation, relates x, relates y, has att1;"
  end

  test "define a relation with multiple attributes" do
    %{graql: graql} =
      defschema("r",
        sub: :relation,
        relates: ["x", "y"],
        has: ["att1", "att2"]
      )

    assert graql === "define r sub relation, relates x, relates y, has att1, has att2;"
  end

  test "define a entity subtype" do
    %{graql: graql} = defschema("user", sub: "person")
    assert graql === "define user sub person;"

    %{graql: graql} = defschema("user", sub: "person", has: ["name"])
    assert graql === "define user sub person, has name;"

    %{graql: graql} = defschema("user", sub: "person", plays: ["actor"])
    assert graql === "define user sub person, plays actor;"

    %{graql: graql} = defschema("user", sub: "person", has: ["name"])
    assert graql === "define user sub person, has name;"

    %{graql: graql} = defschema("user", sub: "person", has: ["name"], plays: ["actor"])
    assert graql === "define user sub person, has name, plays actor;"

    %{graql: graql} = defschema("user", sub: "person", plays: ["actor"], has: ["name"])
    assert graql === "define user sub person, plays actor, has name;"
  end

  test "define a rule" do
    %{graql: graql_from_fun} =
      defschema("rule1",
        sub: :rule,
        when: ["$person has age 1", "$person has name \"alex\""],
        then: "$person has check \"ok\""
      )

    assert graql_from_fun ===
             "define rule1 sub rule, when { $person has age 1; $person has name \"alex\"; }, then { $person has check \"ok\"; };"
  end
end

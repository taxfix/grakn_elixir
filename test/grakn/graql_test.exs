defmodule Grakn.GraqlTest do
  use ExUnit.Case
  use Grakn.Graql

  test "define an attribute" do
    %{graql: graql} =
      define "att", sub: :attribute
    assert graql === "define att sub attribute;"
  end

  test "define an attribute with datatype" do
    %{graql: graql} =
      define "att", sub: :attribute, datatype: datatypes().string
    assert graql === "define att sub attribute, datatype string;"
  end

  test "define an entity" do
    %{graql: graql} = define "something", sub: :entity
    assert graql === "define something sub entity;"
  end

  test "define an entity with attribute" do
    %{graql: graql} =
      define "something", sub: :entity,
        has: "att"
    assert graql === "define something sub entity, has att;"
  end

  test "define an entity with multiple attributes" do
    %{graql: graql} =
      define "something", sub: :entity,
        has: ["att1", "att2"]
    assert graql === "define something sub entity, has att1, has att2;"
  end
end

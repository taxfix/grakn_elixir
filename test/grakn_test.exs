defmodule GraknTest do
  use ExUnit.Case
  doctest Grakn

  test "greets the world" do
    assert Grakn.hello() == :world
  end
end

defmodule GraknElixirTest do
  use ExUnit.Case
  doctest GraknElixir

  test "greets the world" do
    assert GraknElixir.hello() == :world
  end
end

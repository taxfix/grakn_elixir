defmodule Grakn do
  @moduledoc """
  Documentation for Grakn.
  """

  @type conn :: DBConnection.conn()

  @doc """
  Hello world.

  ## Examples

      iex> GraknElixir.hello()
      :world

  """
  def hello do
    :world
  end

  def start_link(opts) do
    DBConnection.start_link(Grakn.Protocol, opts)
  end

  def query(conn, query, opts \\ []) do
    DBConnection.execute(conn, query, [], opts)
  end

  @spec transaction(conn(), (conn() -> result), Keyword.t()) :: {:ok, result} | {:error, any}
        when result: var
  def transaction(conn, fun, opts \\ []) do
    DBConnection.transaction(conn, fun, opts)
  end
end

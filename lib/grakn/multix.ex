defmodule Grakn.Multix do
  @moduledoc """
  Multix allows to manage availiability of resources.
  """

  use GenServer

  @doc false
  def start_link(name, resources) do
    GenServer.start_link(__MODULE__, [name, resources], [])
  end

  @doc false
  def init([name, resources]) do
    :ets.new(name, [:named_table, :public, read_concurrency: true])
    {:ok, resources}
  end
end

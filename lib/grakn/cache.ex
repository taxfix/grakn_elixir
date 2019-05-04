defmodule Grakn.Cache do
  @moduledoc """
  Cache for grakn. Used for sessions at the moment, as sessions are claimed to be a problem
  for performance, so we share sessions for the same keyspace.
  """

  use GenServer

  import Record, only: [defrecord: 2]
  import Ex2ms

  defrecord :entry,
    key: nil,
    touched: nil,
    ttl: nil,
    value: nil

  @key_pos 2
  @touched_pos 3

  @table __MODULE__

  @doc """
  Start cache
  """
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc false
  def init(_opts) do
    :ets.new(@table, [:named_table, :public, keypos: @key_pos, read_concurrency: true])
    {:ok, %{}}
  end

  @doc """
  Get key from cache
  """
  def fetch(key) do
    case :ets.lookup(@table, key) do
      [entry(value: value)] -> value
      [] -> nil
    end
  end

  @doc """
  Put key value in a cache
  """
  def put(key, value, ttl \\ nil) do
    entry = entry(key: key, value: value, ttl: ttl, touched: now())
    :ets.insert(@table, entry)
  end

  @doc """
  Delete key from a cache
  """
  def delete(key) do
    :ets.delete(@table, key)
  end

  @doc """
  Touch key
  """
  def touch(key) do
    :ets.update_element(@table, key, [{@touched_pos, now()}])
    true
  catch
    _, _ ->
      false
  end

  @compile {:inline, now: 0}
  def now, do: :os.system_time(1000)

  @doc """
  Query expired elements
  """
  def expired() do
    select_spec =
      fun do
        entry(ttl: ttl, touched: touched) = entry_elem when touched + ttl < ^now() -> entry_elem
      end

    :ets.select(@table, select_spec)
  end
end

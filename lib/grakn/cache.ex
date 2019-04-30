defmodule Grakn.Cache do
  @moduledoc """
  Cache for grakn. Used for sessions at the moment, as sessions are claimed to be a problem
  for performance, so we share sessions for the same keyspace.
  """

  import Cachex.Spec
  @cache __MODULE__

  @doc """
  Start cache
  """
  def start_link() do
    # We disable default expiration for having a custom expiration process, which can additionally
    # stop sessions
    Cachex.start_link(@cache, expiration: expiration(interval: nil, lazy: false))
  end

  @doc false
  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  @doc """
  Get key from cache
  """
  def fetch(key) do
    with {:ok, result} <- Cachex.get(@cache, key), do: result
  end

  @doc """
  Put key value in a cache
  """
  def put(key, value, opts \\ []) do
    Cachex.put(@cache, key, value, opts)
  end

  @doc """
  Delete key from a cache
  """
  def delete(key) do
    Cachex.del(@cache, key)
  end

  @doc """
  Touch key
  """
  def touch(key) do
    Cachex.touch(@cache, key)
  end
end

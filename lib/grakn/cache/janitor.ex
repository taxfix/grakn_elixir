defmodule Grakn.Cache.Janitor do
  @moduledoc """
  Expiration process to clean up expired cache records periodically.

  This is a modification for `Cachex.Service.Janitor` to execute custom purge command, which
  additionally can attach actions on purged elements.
  """

  alias Grakn.{Cache, Command}

  use GenServer

  require Logger
  require Cache

  @server __MODULE__

  @doc """
  Starts a new Janitor process for a cache.
  """
  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: @server)

  @doc false
  def init(_opts) do
    {:ok, schedule_check()}
  end

  @doc false
  # Executes an expiration cleanup against a cache table.
  def handle_info(:ttl_check, _state) do
    clean_ttl_elements()
    {:noreply, schedule_check()}
  end

  defp schedule_check() do
    interval = Application.get_env(:grakn, :session_ttl_interval, 5_000)
    :erlang.send_after(interval, self(), :ttl_check)
  end

  def clean_ttl_elements() do
    for Cache.entry(key: key, value: value) <- Cache.expired() do
      close_session(key, value)
    end
  end

  defp close_session(key, %{session_id: session_id, name: name}) do
    try do
      {:ok, _} = Grakn.command(name, Command.close_session(session_id))
      Cache.delete(key)
    catch
      type, error ->
        error_spec = {type, error, __STACKTRACE__}
        Logger.warn("Couldn't close session #{session_id}, error: #{inspect(error_spec)}")
        Cache.delete(key)
    end
  end
end

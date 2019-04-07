defmodule Grakn do
  @moduledoc """
  The main entry point for interacting with Grakn. All functions take a
  connection reference.
  """

  @typedoc """
  A connection process name, pid or reference.
  A connection reference is used when making multiple requests within a
  transaction, see `transaction/3`.
  """
  @type conn :: DBConnection.conn()

  @doc """
  Start and link to a Grakn connnection process.

  ### Single-server Options
    * `:hostname` - The hostname of the Grakn server to connect to (required)
    * `:port` - The port of the Grakn server (default: 48555)

  ### Muti-server Options
    * `:servers` - A list of server options (e.g. [[hostname: "10.0.0.1", port: 48555], [hostname: "10.0.0.2"]])
  """
  @spec start_link(Keyword.t()) :: {:ok, conn()} | {:error, any}
  def start_link(opts \\ []) do
    DBConnection.start_link(Grakn.Protocol, with_start_config(opts))
  end

  @doc """
  Execute a query on the connection process. Queries can anly be run run within
  a transaction, see `transaction/3`.

  ### Options
    * `:include_inferences` - Boolean specifying if inferences should be
      included in the querying process (default: true)
  """
  @spec query(conn(), Grakn.Query.t(), Keyword.t()) :: any()
  def query(conn, query, opts \\ []) do
    DBConnection.execute(conn, query, [], with_transaction_config(opts))
  end

  @doc """
  Execute a query on the connection process and raise an exception if there is
  an error. See `query/3` for documentation.
  """
  @spec query!(conn(), Grakn.Query.t(), Keyword.t()) :: any()
  def query!(conn, %Grakn.Query{} = query, opts \\ []) do
    DBConnection.execute!(conn, query, [], with_transaction_config(opts))
  end

  @spec command(conn(), Grakn.Command.t(), Keyword.t()) :: any()
  def command(conn, %Grakn.Command{} = command, opts \\ []) do
    DBConnection.execute(conn, command, [], with_transaction_config(opts))
  end

  @doc """
  Create a new transaction and execute a sequence of statements within the
  context of the transaction.

  ### Options
    * `:type` - The type of transaction, value must be
      `Grakn.Transaction.Type.read()` (default), or
      `Grakn.Transaction.Type.write()`

  ### Example
  ```
  Grakn.transaction(
    conn,
    fn conn ->
      Grakn.query(conn, Grakn.Query.graql("match $x isa Person; get;"))
    end
  )
  ```
  """
  @spec transaction(conn(), (conn() -> result), Keyword.t()) :: {:ok, result} | {:error, any}
        when result: var
  def transaction(conn, fun, opts \\ []) do
    DBConnection.transaction(conn, fun, with_transaction_config(opts))
  end

  @doc """
  Rollback a transaction, does not return.
  Aborts the current transaction fun. If inside multiple `transaction/3`
  functions, bubbles up to the top level.
  ## Example
      {:error, :oops} = Grakn.transaction(pid, fn(conn) ->
        Grakn.rollback(conn, :oops)
        IO.puts "never reaches here!"
      end)
  """
  @spec rollback(DBConnection.t(), any) :: no_return()
  defdelegate rollback(conn, any), to: DBConnection

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  defp with_start_config(opts) do
    opts
    |> Keyword.put_new(:pool_size, get_config(:pool_size, 4))
    |> Keyword.put_new(:pool, DBConnection.Poolboy)
  end

  defp with_transaction_config(opts) do
    opts_with_defaults =
      opts
      |> Keyword.put_new(:pool_size, get_config(:pool_size, 4))
      |> Keyword.put_new(:pool, DBConnection.Poolboy)
      |> Keyword.put_new(:pool_timeout, get_config(:pool_timeout, :infinity))
      |> Keyword.put_new(:timeout, get_config(:timeout, 30_000))
      |> Keyword.put_new(:queue, get_config(:queue, true))
      |> Keyword.put_new(:username, get_config(:username, ""))
      |> Keyword.put_new(:password, get_config(:password, ""))

    case get_config(:log) do
      nil -> opts_with_defaults
      log_function -> opts_with_defaults |> Keyword.put_new(:log, log_function)
    end
  end

  defp get_config(key, default \\ nil),
    do: Application.get_env(:grakn_elixir, key, default)
end

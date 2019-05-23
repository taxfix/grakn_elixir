defmodule Grakn do
  @moduledoc """
  The main entry point for interacting with Grakn. All functions take a
  connection reference.
  """

  @behaviour Multix.OnFailure

  @typedoc """
  A connection process name, pid or reference.
  A connection reference is used when making multiple requests within a
  transaction, see `transaction/3`.
  """
  @type conn :: DBConnection.conn()
  @default_timeout :timer.minutes(5)

  @doc """
  Start and link to a Grakn connnection process.

  ### Single-server Options
    * `:hostname` - The hostname of the Grakn server to connect to (default: "localhost")
    * `:port` - The port of the Grakn server (default: 48555)

  ### Muti-server Options
    * `:servers` - A list of server options (e.g. [[hostname: "10.0.0.1", port: 48555], [hostname: "10.0.0.2"]])
      `:name` is required to use alongside of this option
  """
  @spec start_link(Keyword.t()) :: {:ok, conn()} | {:error, any}
  def start_link(opts \\ []) do
    opts = with_start_config(opts)

    case Keyword.get(opts, :servers) do
      list when is_list(list) -> Grakn.Sup.start_link(opts)
      nil -> DBConnection.start_link(Grakn.Protocol, opts)
    end
  end

  @doc """
  Execute a query on the connection process. Queries can anly be run run within
  a transaction, see `transaction/3`.

  ### Options
    * `:include_inferences` - Boolean specifying if inferences should be
      included in the querying process (default: true)
    * `:stream` - Boolean specifying if stream should be returned (default: false)
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
    DBConnection.execute!(get_conn(conn), query, [], with_transaction_config(opts))
  end

  @spec command(conn(), Grakn.Command.t(), Keyword.t()) :: any()
  def command(conn, %Grakn.Command{} = command, opts \\ []) do
    DBConnection.execute(get_conn(conn), command, [], with_transaction_config(opts))
  end

  @known_connection_errors [":shutdown: :econnrefused", ":noproc"]

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
    keyspace = opts[:keyspace] || "grakn"
    chosen_conn = get_conn(conn, keyspace)

    with {:error, error, stacktrace} <- do_transaction(chosen_conn, fun, opts) do
      case error do
        %DBConnection.ConnectionError{} ->
          Multix.failure(conn, chosen_conn)

        %Grakn.Error{reason: %GRPC.RPCError{message: message}}
        when message in @known_connection_errors ->
          Multix.failure(conn, chosen_conn)

        _ ->
          nil
      end

      reraise error, stacktrace
    end
  end

  defp do_transaction(conn, fun, opts) do
    opts = with_transaction_config(opts)

    try do
      DBConnection.transaction(conn, fun, opts)
    rescue
      error -> {:error, error, __STACKTRACE__}
    end
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

  @health_check "health_check"

  def check(conn) do
    opts = [keyspace: @health_check, type: Grakn.Transaction.Type.write()]

    case do_transaction(conn, &check_query/1, opts) do
      {:error, _, _} -> :error
      {:ok, _} -> :ok
    end
  end

  defp check_query(conn) do
    Grakn.query!(conn, Grakn.Query.graql("match $x isa thing; get; limit 1;"), stream: true)
  end

  @doc false
  def connection_uri(opts) do
    "#{Keyword.get(opts, :hostname, "localhost")}:#{Keyword.get(opts, :port, 48555)}"
  end

  def child_spec(opts) do
    type = if Keyword.has_key?(opts, :servers), do: :supervisor, else: :worker

    %{
      id: {__MODULE__, opts[:name]},
      start: {__MODULE__, :start_link, [opts]},
      type: type
    }
  end

  @compile {:inline, get_conn: 1}
  defp get_conn(conn), do: get_conn(conn, nil)

  @compile {:inline, get_conn: 2}
  defp get_conn(conn, data) when is_atom(conn) do
    case Multix.get(conn, data) do
      nil -> raise Grakn.Error, "no servers available"
      # disabled, so we return conn
      :error -> conn
      chosen_conn -> chosen_conn
    end
  end

  defp get_conn(conn, _data), do: conn

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
      |> Keyword.put_new(:pool_timeout, get_config(:pool_timeout, 30_000))
      |> Keyword.put_new(:timeout, get_config(:timeout, @default_timeout))
      |> Keyword.put_new(:queue, get_config(:queue, true))
      |> Keyword.put_new(:username, get_config(:username, ""))
      |> Keyword.put_new(:password, get_config(:password, ""))

    case get_config(:log) do
      nil -> opts_with_defaults
      log_function -> Keyword.put_new(opts_with_defaults, :log, log_function)
    end
  end

  defp get_config(key, default \\ nil),
    do: Application.get_env(:grakn_elixir, key, default)
end

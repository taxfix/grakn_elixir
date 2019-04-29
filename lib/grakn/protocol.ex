defmodule Grakn.Protocol do
  @moduledoc """
  This is the DBConnection behaviour implementation for Grakn database
  """
  alias Grakn.{Error, Session, Transaction}

  require Logger

  use DBConnection

  defstruct [:session, :transaction]

  defguardp transaction_open?(tx) when not is_nil(tx)

  def checkin(state) do
    # empty - process is independent from state
    {:ok, state}
  end

  def checkout(state) do
    # empty - process is independent from state
    {:ok, state}
  end

  def connect(opts) do
    with {:ok, session} <- Session.new(connection_uri(opts)) do
      {:ok, %__MODULE__{session: session}}
    end
  end

  def disconnect(_error, %{session: session}) do
    Session.close(session)
  end

  def handle_begin(_opts, %{transaction: tx} = state) when not is_nil(tx) do
    {:error, Error.exception("Transaction already opened on this connection"), state}
  end

  def handle_begin(opts, %{session: session} = state) do
    keyspace = opts[:keyspace] || "grakn"
    type = opts[:type] || Transaction.Type.read()

    with {:ok, tx, session_id} <-
           Session.transaction(session, keyspace, opts[:username], opts[:password]),
         {:ok, tx} <- Transaction.open(tx, session_id, type) do
      {:ok, nil, %{state | transaction: tx}}
    else
      {:error, reason} ->
        reason_msg = Map.get(reason, :message, "unknown")
        exception = Error.exception("Failed to create transaction. Reason: #{reason_msg}", reason)
        {:error, exception, state}
    end
  end

  def handle_commit(_opts, %{transaction: tx} = state) when transaction_open?(tx) do
    with :ok <- Transaction.commit(tx) do
      {:ok, nil, %{state | transaction: nil}}
    end
  end

  def handle_commit(_opts, state) do
    {:error, Error.exception("Cannot commit if transaction is not open"), state}
  end

  def handle_execute(%{graql: graql}, _params, opts, %{transaction: tx} = state)
      when transaction_open?(tx) do
    case Transaction.query(tx, graql, opts) do
      {:ok, result} ->
        {:ok, result, state}

      {:error, reason} ->
        {:error,
         Error.exception(
           "Failed to execute #{inspect(graql, limit: :infinity)}. Reason: #{
             Map.get(reason, :message, "unknown")
           }",
           reason
         ), state}
    end
  end

  def handle_execute(%Grakn.Query{}, _, _, state) do
    {:error, Error.exception("Cannot execute a query before starting a tranaction"), state}
  end

  def handle_execute(
        %Grakn.Command{command: command, params: params},
        _,
        _,
        %{session: session} = state
      ) do
    session
    |> Session.command(command, params)
    |> Tuple.append(state)
  end

  # Handle internal concept actions
  def handle_execute(
        %Grakn.Concept.Action{name: action_name},
        params,
        _,
        %{transaction: tx} = state
      )
      when is_atom(action_name) and is_list(params) do
    Transaction
    |> apply(action_name, [tx | params])
    |> Tuple.append(state)
  end

  def handle_rollback(_opts, %{transaction: tx} = state) do
    if Transaction.cancel(tx) !== :ok do
      Logger.warn("Failed to rollback transaction")
    end

    {:ok, nil, %{state | transaction: nil}}
  end

  defp connection_uri(opts) do
    "#{Keyword.get(opts, :hostname, "localhost")}:#{Keyword.get(opts, :port, 48555)}"
  end
end

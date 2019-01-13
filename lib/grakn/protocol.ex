defmodule Grakn.Protocol do
  @moduledoc """
  This is the DBConnection behaviour implementation for Grakn database
  """

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
    case Grakn.Session.new(connection_uri(opts)) do
      {:ok, session} -> {:ok, %__MODULE__{session: session}}
    end
  end

  def disconnect(_error, %{session: session}) do
    Grakn.Session.close(session)
  end

  def handle_begin(_opts, %{transaction: tx} = state) when not is_nil(tx) do
    {:error, Grakn.Error.exception("Transaction already opened on this connection"), state}
  end

  def handle_begin(opts, %{session: session} = state) do
    with {:ok, tx} <- Grakn.Session.transaction(session),
         {:ok, tx} <-
           Grakn.Transaction.open(
             tx,
             opts[:keyspace] || "grakn",
             opts[:type] || Grakn.Transaction.Type.read()
           ) do
      {:ok, nil, %{state | transaction: tx}}
    else
      {:error, reason} ->
        {:disconnect, Grakn.Error.exception("Failed to create transaction", reason), state}
    end
  end

  def handle_commit(_opts, %{transaction: tx} = state) when transaction_open?(tx) do
    :ok = Grakn.Transaction.commit(tx)
    {:ok, nil, %{state | transaction: nil}}
  end

  def handle_commit(_opts, state) do
    {:error, Grakn.Error.exception("Cannot commit if transaction is not open"), state}
  end

  def handle_execute(%{graql: graql}, _params, opts, %{transaction: tx} = state)
      when transaction_open?(tx) do
    case Grakn.Transaction.query(tx, graql, Keyword.get(opts, :include_inferences)) do
      {:ok, iterator} ->
        {:ok, iterator, state}

      {:error, reason} ->
        {:error,
         Grakn.Error.exception(
           "Failed to execute #{inspect(graql)}. Reason: #{Map.get(reason, :message, "unknown")}",
           reason
         ), state}
    end
  end

  def handle_execute(%Grakn.Query{}, _, _, state) do
    {:error, Grakn.Error.exception("Cannot execute a query before starting a tranaction"), state}
  end

  def handle_execute(
        %Grakn.Command{command: command, params: params},
        _,
        _,
        %{session: session} = state
      ) do
    session
    |> Grakn.Session.command(command, params)
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
    Grakn.Transaction
    |> apply(action_name, [tx | params])
    |> Tuple.append(state)
  end

  def handle_rollback(_opts, %{transaction: tx} = state) do
    :ok = Grakn.Transaction.cancel(tx)
    {:ok, nil, %{state | transaction: nil}}
  end

  defp connection_uri(opts) do
    "#{Keyword.fetch!(opts, :hostname)}:#{Keyword.get(opts, :port, 48555)}"
  end
end

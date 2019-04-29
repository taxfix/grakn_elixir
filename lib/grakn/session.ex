defmodule Grakn.Session do
  @moduledoc false

  @opaque t :: GRPC.Channel.t()

  # every 5 min
  @ping_rate 300_000

  @spec new(String.t()) :: {:ok, t()} | {:error, any()}
  def new(uri) do
    GRPC.Stub.connect(uri, adapter_opts: %{http2_opts: %{keepalive: @ping_rate}})
  end

  @spec transaction(t(), String.t(), String.t(), String.t()) ::
          {:ok, Grakn.Transaction.t(), String.t()} | {:error, any()}
  def transaction(channel, keyspace, username, password) do
    Grakn.Transaction.new(channel, keyspace, username, password)
  end

  @spec command(t(), Grakn.Command.command(), keyword()) :: {:ok, any()} | {:error, any()}
  def command(channel, :get_keyspaces, _) do
    request = Keyspace.Keyspace.Retrieve.Req.new()

    case Keyspace.KeyspaceService.Stub.retrieve(channel, request) do
      {:ok, %Keyspace.Keyspace.Retrieve.Res{names: names}} ->
        {:ok, names}

      {:error, reason} ->
        {:error, reason}

      resp ->
        {:error, "Unexpected response from service #{inspect(resp)}"}
    end
  end

  def command(channel, :create_keyspace, name: name) do
    request = Keyspace.Keyspace.Create.Req.new(name: name)

    case Keyspace.KeyspaceService.Stub.create(channel, request) do
      {:ok, %Keyspace.Keyspace.Create.Res{}} -> {:ok, nil}
      error -> error
    end
  end

  def command(channel, :delete_keyspace, name: name) do
    request = Keyspace.Keyspace.Delete.Req.new(name: name)

    case Keyspace.KeyspaceService.Stub.delete(channel, request) do
      {:ok, %Keyspace.Keyspace.Delete.Res{}} -> {:ok, nil}
      error -> error
    end
  end

  @spec close(t()) :: :ok
  def close(channel) do
    GRPC.Stub.disconnect(channel)
    :ok
  end
end

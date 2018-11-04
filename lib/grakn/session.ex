defmodule Grakn.Session do
  @opaque t :: GRPC.Channel.t()

  @spec new(String.t()) :: t()
  def new(uri) do
    GRPC.Stub.connect(uri)
  end

  @spec transaction(t()) :: {:ok, Grakn.Transaction.t()} | {:error, any()}
  @spec transaction(GRPC.Channel) ::
          {:ok,
           {{:error, map()} | {:ok, any()} | {:ok, map(), map()} | GRPC.Client.Stream.t(), []}}
  def transaction(channel) do
    channel
    |> Grakn.Transaction.new()
  end

  @spec close(t()) :: :ok
  def close(channel) do
    channel
    |> GRPC.Stub.end_stream()
    :ok
  end
end

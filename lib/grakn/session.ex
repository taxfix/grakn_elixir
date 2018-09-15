defmodule Grakn.Session do
  @opaque t :: pid()

  @spec start_link(String.t()) :: {:ok, t()} | {:error, any()}
  def start_link(uri) do
    {:ok, channel} = GRPC.Stub.connect(uri)
    Agent.start_link(fn -> channel end)
  end

  @spec transaction(t()) :: {:ok, Grakn.Transaction.t()} | {:error, any()}
  def transaction(session) do
    session
    |> get_channel
    |> Session.SessionService.Stub.transaction()
    |> Grakn.Transaction.start_link()
  end

  @spec close(t()) :: :ok
  def close(session) do
    session
    |> get_channel
    |> GRPC.Stub.end_stream()

    Agent.stop(session)
  end

  defp get_channel(session) do
    Agent.get(session, & &1)
  end
end

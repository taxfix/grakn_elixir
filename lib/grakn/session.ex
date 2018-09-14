defmodule Grakn.Session do
  def start_link(uri) do
    {:ok, channel} = GRPC.Stub.connect(uri)
    Agent.start_link(fn -> channel end)
  end

  def transaction(session) do
    session
    |> get_channel
    |> Session.SessionService.Stub.transaction()
    |> Grakn.Transaction.start_link()
  end

  defp get_channel(session) do
    Agent.get(session, & &1)
  end
end

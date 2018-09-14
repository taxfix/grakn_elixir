defmodule Grakn.Transaction do
  def start_link(channel) do
    Agent.start_link(fn -> {channel, []} end)
  end

  def open(tx, keyspace \\ "grakn") do
    request =
      transaction_request(
        :open_req,
        Session.Transaction.Open.Req.new(keyspace: keyspace, type: 0)
      )

    {:ok, resp_stream} =
      tx
      |> send_request(request)
      |> GRPC.Stub.recv()

    {:ok, _} = Enum.at(resp_stream, 0)

    Agent.update(tx, fn {req_stream, _} -> {req_stream, resp_stream} end)
  end

  def commit(tx) do
    request =
        transaction_request(
            :commit_req,
            Session.Transaction.Commit.Req.new()
        )
    tx |> send_request(request)
    {:ok,_} = get_response(tx)
    Agent.stop(tx)
  end

  def query(tx, query) do
    request =
      transaction_request(
        :query_req,
        Session.Transaction.Query.Req.new(query: query, infer: 0)
      )

    tx |> send_request(request)

    case get_response(tx) do
      {:ok, %{res: {:query_iter, %{id: iterator_id}}}} -> {:ok, create_iterator(tx, iterator_id)}
      {:error, _} = resp -> resp
    end
  end

  defp create_iterator(tx, id) do
    Stream.unfold(
      tx,
      fn tx ->
        tx
        |> send_request(
          transaction_request(
            :iterate_req,
            Session.Transaction.Iter.Req.new(id: id)
          )
        )

        case get_response(tx) do
          {:ok, %{res: {:iterate_res, %{res: {:done, _}}}}} ->
            nil

          {:ok, %{res: {:iterate_res, %{res: {:query_iter_res, %{answer: answer}}}}}} ->
            {answer, tx}
        end
      end
    )
  end

  defp transaction_request(type, request) do
    Session.Transaction.Req.new(req: {type, request})
  end

  defp get_response(tx) do
    tx
    |> get_response_stream
    |> Enum.at(0)
  end

  defp send_request(tx, request) do
    tx
    |> get_request_stream
    |> GRPC.Stub.send_request(request)
  end

  defp get_state(tx) do
    Agent.get(tx, & &1)
  end

  defp get_request_stream(tx) do
    {req_stream, _} = get_state(tx)
    req_stream
  end

  defp get_response_stream(tx) do
    {_, resp_stream} = get_state(tx)
    resp_stream
  end
end

defmodule Grakn.Transaction do
  defmodule Type do
    @read 0
    @write 1
    @batch 2

    @type t :: unquote(@read) | unquote(@write) | unquote(@batch)

    def read, do: @read
    def write, do: @write
    def batch, do: @batch
  end

  @opaque t :: pid()

  @spec start_link(GRPC.Client.Stream.t()) :: {:ok, t()} | {:error, any}
  def start_link(req_stream) do
    Agent.start_link(fn -> {req_stream, []} end)
  end

  @spec open(t(), String.t(), Type.t()) :: :ok
  def open(tx, keyspace \\ "grakn", type \\ Type.read()) do
    request =
      transaction_request(
        :open_req,
        Session.Transaction.Open.Req.new(keyspace: keyspace, type: type)
      )

    {:ok, resp_stream} =
      tx
      |> send_request(request)
      |> GRPC.Stub.recv()

    {:ok, _} = Enum.at(resp_stream, 0)

    Agent.update(tx, fn {req_stream, _} -> {req_stream, resp_stream} end)
  end

  @spec commit(t()) :: :ok
  def commit(tx) do
    request =
      transaction_request(
        :commit_req,
        Session.Transaction.Commit.Req.new()
      )

    tx |> send_request(request)
    {:ok, _} = get_response(tx)
    Agent.stop(tx)
  end

  def cancel(tx) do
    tx
    |> get_request_stream
    |> GRPC.Stub.cancel()

    Agent.stop(tx)
  end

  @spec query(t(), String.t(), boolean()) :: {:ok, Enumerable.t()} | {:error, any()}
  def query(tx, query, include_inferences \\ true) do
    infer = if include_inferences, do: 0, else: 1

    request =
      transaction_request(
        :query_req,
        Session.Transaction.Query.Req.new(query: query, infer: infer)
      )

    tx |> send_request(request)

    case get_response(tx) do
      {:ok, %{res: {:query_iter, %{id: iterator_id}}}} -> {:ok, create_iterator(tx, iterator_id)}
      {:error, _} = resp -> resp
    end
  end

  @spec put_attribute_type(t(), String.t(), any) :: {:ok, Grakn.Concept.t()} | {:error, any()}
  def put_attribute_type(tx, label, data_type) do
    request =
      transaction_request(
        :putAttributeType_req,
        Session.Transaction.PutAttributeType.Req.new(label: label, dataType: data_type)
      )
    tx |> send_request(request)

    case get_response(tx) do
      {:ok, %{attributeType: concept}} -> {:ok, concept}
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

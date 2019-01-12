defmodule Grakn.Transaction do
  @moduledoc false

  defmodule Type do
    @moduledoc false

    @read 0
    @write 1
    @batch 2

    @type t :: unquote(@read) | unquote(@write) | unquote(@batch)

    def read, do: @read
    def write, do: @write
    def batch, do: @batch
  end

  @opaque t :: {GRPC.Client.Stream.t(), GRPC.Client.Stream.t()}

  @spec new(GRPC.Channel.t()) :: {:ok, t()} | {:error, any}
  def new(channel) do
    req_stream =
      channel
      |> Session.SessionService.Stub.transaction()
    {:ok, {req_stream, []}}
  end

  @spec open(t(), String.t(), Type.t()) :: {:ok, t()}
  def open(tx, keyspace, type) do
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

    {:ok, put_elem(tx, 1, resp_stream)}
  end

  @spec commit(t()) :: :ok
  def commit(tx) do
    request =
      transaction_request(
        :commit_req,
        Session.Transaction.Commit.Req.new()
      )

    tx |> send_request(request, end_stream: true)
    {:ok, _} = get_response(tx)
    :ok
  end

  def cancel(tx) do
    tx
    |> get_request_stream
    |> GRPC.Stub.cancel()
    :ok
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
      error -> error
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

          {:ok, %{res: {:iterate_res, %{res: {:query_iter_res, %{answer: %{answer: answer}}}}}}} ->
            {Grakn.Answer.unwrap(answer), tx}
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

  defp send_request(tx, request, opts \\ []) do
    tx
    |> get_request_stream
    |> GRPC.Stub.send_request(request, opts)
  end


  defp get_request_stream({req_stream, _}), do: req_stream
  defp get_response_stream({_, resp_stream}), do: resp_stream
end

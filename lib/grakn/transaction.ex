defmodule Grakn.Transaction do
  @moduledoc false
  alias Grakn.Transaction.Request

  require Logger

  defmodule Type do
    @moduledoc false

    @read 0
    @write 1
    @batch 2

    @opaque t :: unquote(@read) | unquote(@write) | unquote(@batch)

    def read, do: @read
    def write, do: @write
    def batch, do: @batch
  end

  # 1 hour
  @transaction_timeout 3.6e+6

  @opaque t :: {GRPC.Client.Stream.t(), Enumerable.t()} | {Enumerable.t(), nil}

  @spec new(GRPC.Channel.t()) :: {:ok, t()} | {:error, any()}
  def new(channel) do
    req_stream =
      channel
      |> Session.SessionService.Stub.transaction(timeout: @transaction_timeout)

    with %GRPC.Client.Stream{} <- req_stream do
      {:ok, {req_stream, nil}}
    else
      {:error, reason} ->
        {:error, reason}

      error ->
        Logger.error("Unable to start transaction stream: #{inspect(error)}")
        {:error, "Unable to start transaction stream"}
    end
  end

  @spec open(t(), String.t(), Type.t(), Type.t(), Type.t()) :: {:ok, t()}
  def open(tx, keyspace, type, username, password) do
    request = Request.open_transaction(keyspace, type, username, password)

    req_stream =
      tx
      |> send_request(request)

    with {:ok, resp_stream} <- GRPC.Stub.recv(req_stream),
         {:ok, _} <- Enum.at(resp_stream, 0) do
      {:ok, {req_stream, resp_stream}}
    end
  end

  @spec commit(t()) :: :ok
  def commit(tx) do
    request = Request.commit_transaction()

    req_stream =
      tx
      |> send_request(request)

    with {:ok, _} <- get_response(tx) do
      GRPC.Stub.end_stream(req_stream)
      :ok
    end
  end

  @spec cancel(t()) :: :ok
  def cancel(tx) do
    tx
    |> get_request_stream
    |> GRPC.Stub.end_stream()
    |> GRPC.Stub.cancel()

    :ok
  end

  @spec query(t(), String.t(), boolean()) :: {:ok, Enumerable.t()} | {:error, any()}
  def query(tx, query, include_inferences \\ true) do
    infer = if include_inferences, do: 0, else: 1

    req_stream = send_request(tx, Request.query(query, infer))

    case get_response(tx) do
      {:ok, %{res: {:query_iter, %{id: iterator_id}}}} ->
        {:ok, create_iterator({req_stream, get_response_stream(tx)}, iterator_id)}

      error ->
        error
    end
  end

  def attribute_value(tx, attribute_id) when is_bitstring(attribute_id) do
    tx |> send_request(Request.attribute_value(attribute_id))

    with {:ok, %{res: answer}} <- get_response(tx) do
      {:ok, Grakn.Answer.unwrap(answer)}
    end
  end

  defp create_iterator(tx, id) do
    Stream.unfold(
      tx,
      fn tx ->
        req_stream = send_request(tx, Request.iterator(id))

        case get_response(tx) do
          {:ok, %{res: {:iterate_res, %{res: {:done, _}}}}} ->
            nil

          {:ok, %{res: {:iterate_res, %{res: {:query_iter_res, %{answer: %{answer: answer}}}}}}} ->
            {Grakn.Answer.unwrap(answer), {req_stream, get_response_stream(tx)}}

          error ->
            error
        end
      end
    )
  end

  defp get_response(tx) do
    tx
    |> get_response_stream
    |> Enum.at(0)
  end

  @spec send_request(t(), any(), keyword()) :: GRPC.Client.Stream.t()
  defp send_request(tx, request, opts \\ []) do
    tx
    |> get_request_stream()
    |> GRPC.Stub.send_request(request, opts)
  end

  defp get_request_stream({req_stream, _}), do: req_stream
  defp get_response_stream({_, resp_stream}), do: resp_stream
end

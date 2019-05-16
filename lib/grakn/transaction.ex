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
  # 5 min
  @request_timeout 300_000

  @opaque t :: {GRPC.Client.Stream.t(), Enumerable.t()} | {Enumerable.t(), nil}

  @spec new(GRPC.Channel.t(), String.t()) :: {:ok, t(), String.t()} | {:error, any()}
  def new(channel, keyspace) do
    with {:ok, %{sessionId: session_id}} <-
           Session.SessionService.Stub.open(
             channel,
             Session.Session.Open.Req.new(Keyspace: keyspace)
           ),
         req_stream <-
           Session.SessionService.Stub.transaction(channel, timeout: @transaction_timeout),
         %GRPC.Client.Stream{} <- req_stream do
      {:ok, {req_stream, nil}, session_id}
    else
      {:error, reason} ->
        {:error, reason}

      error ->
        Logger.error("Unable to start transaction stream: #{inspect(error)}")
        {:error, "Unable to start transaction stream"}
    end
  end

  @spec open(t(), String.t(), Type.t(), String.t(), String.t()) :: {:ok, t()}
  def open(tx, session_id, type, username, password) do
    request = Request.open_transaction(session_id, type, username, password)
    req_stream = send_request(tx, request)

    with {:ok, resp_stream} <- GRPC.Stub.recv(req_stream, timeout: @request_timeout),
         {:ok, _} <- Enum.at(resp_stream, 0) do
      {:ok, {req_stream, resp_stream}}
    end
  end

  @spec commit(t()) :: :ok
  def commit(tx) do
    request = Request.commit_transaction()
    req_stream = send_request(tx, request)

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

  @spec query(t(), String.t(), Keyword.t()) :: {:ok, Enumerable.t()} | {:error, any()}
  def query(tx, query, opts \\ []) do
    infer = if opts[:include_inferences], do: 0, else: 1

    req_stream = send_request(tx, Request.query(query, infer))

    case get_response(tx) do
      {:ok, %{res: {:query_iter, %{id: iterator_id}}}} ->
        {:ok, get_result({req_stream, get_response_stream(tx)}, iterator_id, opts)}

      error ->
        error
    end
  end

  def attribute_value(tx, attribute_id) when is_binary(attribute_id) do
    send_request(tx, Request.attribute_value(attribute_id))

    with {:ok, %{res: answer}} <- get_response(tx) do
      {:ok, Grakn.Answer.unwrap(answer)}
    end
  end

  def attributes_by_type(tx, concept_id, attribute_types)
      when is_binary(concept_id) and is_list(attribute_types) do
    send_request(tx, Request.attributes_by_type(concept_id, attribute_types))

    with {:ok, %{res: answer}} <- get_response(tx),
         {:thing_attributes_iter, %{id: iterator_id}} <- Grakn.Answer.unwrap(answer) do
      {:ok, create_iterator(tx, iterator_id)}
    end
  end

  def get_schema_concept(tx, label) when is_binary(label) do
    send_request(tx, Request.get_schema_concept(label))

    with {:ok, %{res: answer}} <- get_response(tx) do
      {:ok, Grakn.Answer.unwrap(answer)}
    end
  end

  def get_attribute_types(tx, concept_id) when is_binary(concept_id) do
    send_request(tx, Request.get_attribute_types(concept_id))

    with {:ok, %{res: answer}} <- get_response(tx),
         {:type_attributes_iter, %{id: iterator_id}} <- Grakn.Answer.unwrap(answer) do
      {:ok, create_iterator(tx, iterator_id)}
    end
  end

  def concept_label(tx, concept_id) when is_binary(concept_id) do
    send_request(tx, Request.concept_label(concept_id))

    with {:ok, %{res: answer}} <- get_response(tx) do
      {:ok, Grakn.Answer.unwrap(answer)}
    end
  end

  defp get_result(tx, id, opts) do
    iterator = create_iterator(tx, id)
    if opts[:stream], do: iterator, else: Enum.to_list(iterator)
  end

  defp create_iterator(tx, id) do
    Stream.unfold(tx, &handle_iterator(&1, id))
  end

  defp handle_iterator(tx, id) do
    req_stream = send_request(tx, Request.iterator(id))

    case get_response(tx) do
      {:ok, %{res: {:iterate_res, %{res: {:done, _}}}}} ->
        nil

      {:ok, %{res: {:conceptMethod_iter_res, %{res: {:done, _}}}}} ->
        nil

      {:ok, %{res: {:iterate_res, %{res: answer}}}} ->
        {Grakn.Answer.unwrap(answer), {req_stream, get_response_stream(tx)}}

      {:ok, %{res: {:conceptMethod_iter_res, %{res: answer}}}} ->
        {Grakn.Answer.unwrap(answer), {req_stream, get_response_stream(tx)}}
    end
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

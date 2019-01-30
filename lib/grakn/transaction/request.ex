defmodule Grakn.Transaction.Request do
  @moduledoc false

  def open_transaction(keyspace, type, username, password) do
    transaction_request(
      :open_req,
      Session.Transaction.Open.Req.new(
        keyspace: keyspace,
        type: type,
        username: username,
        password: password
      )
    )
  end

  def commit_transaction() do
    transaction_request(
      :commit_req,
      Session.Transaction.Commit.Req.new()
    )
  end

  def query(query, infer) do
    transaction_request(
      :query_req,
      Session.Transaction.Query.Req.new(query: query, infer: infer)
    )
  end

  def iterator(iterator_id) do
    transaction_request(
      :iterate_req,
      Session.Transaction.Iter.Req.new(id: iterator_id)
    )
  end

  def attribute_value(attribute_id) do
    concept_method_request(attribute_id, :attribute_value_req, Session.Attribute.Value.Req.new())
  end

  defp concept_method_request(concept_id, type, request) do
    transaction_request(
      :conceptMethod_req,
      Session.Transaction.ConceptMethod.Req.new(
        id: concept_id,
        method: Session.Method.Req.new(req: {type, request})
      )
    )
  end

  defp transaction_request(type, request) do
    Session.Transaction.Req.new(req: {type, request})
  end
end

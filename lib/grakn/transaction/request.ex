defmodule Grakn.Transaction.Request do
  @moduledoc false

  def open_transaction(session_id, type, username, password) do
    req_opts = [sessionId: session_id, type: type, username: username, password: password]
    request = Session.Transaction.Open.Req.new(req_opts)
    transaction_request(:open_req, request)
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

  def attributes_by_type(concept_id, attribute_types) do
    concept_method_request(
      concept_id,
      :thing_attributes_req,
      Session.Thing.Attributes.Req.new(attributeTypes: attribute_types)
    )
  end

  def get_schema_concept(label) do
    transaction_request(
      :getSchemaConcept_req,
      Session.Transaction.GetSchemaConcept.Req.new(label: label)
    )
  end

  def get_attribute_types(concept_id) do
    concept_method_request(concept_id, :type_attributes_req, Session.Type.Attributes.Req.new())
  end

  def concept_label(concept_id) do
    concept_method_request(
      concept_id,
      :schemaConcept_getLabel_req,
      Session.SchemaConcept.GetLabel.Req.new()
    )
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

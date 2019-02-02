defmodule Grakn.Answer do
  @moduledoc false
  def unwrap({:value, %Session.Value{number: %Session.Number{value: value}}})
      when is_binary(value) do
    if String.match?(value, ~r/\d+\.\d+/) do
      String.to_float(value)
    else
      String.to_integer(value)
    end
  end

  def unwrap({:conceptMap, %Session.ConceptMap{map: map}}), do: map
  def unwrap({:conceptSet, %Session.ConceptSet{set: %Session.ConceptIds{ids: ids}}}), do: ids

  def unwrap(
        {:conceptMethod_res,
         %Session.Transaction.ConceptMethod.Res{
           response: %Session.Method.Res{
             res:
               {:attribute_value_res,
                %Session.Attribute.Value.Res{
                  value: %Session.ValueObject{value: {_, value}}
                }}
           }
         }}
      ),
      do: value

  def unwrap(
        {:conceptMethod_res,
         %Session.Transaction.ConceptMethod.Res{response: %Session.Method.Res{res: res}}}
      ),
      do: res

  def unwrap(
        {:conceptMethod_iter_res,
         %Session.Method.Iter.Res{
           attribute_owners_iter_res: nil,
           relationType_roles_iter_res: nil,
           relation_rolePlayersMap_iter_res: nil,
           relation_rolePlayers_iter_res: nil,
           role_players_iter_res: nil,
           role_relations_iter_res: nil,
           schemaConcept_subs_iter_res: nil,
           schemaConcept_sups_iter_res: nil,
           thing_attributes_iter_res: %Session.Thing.Attributes.Iter.Res{
             attribute: attribute
           },
           thing_keys_iter_res: nil,
           thing_relations_iter_res: nil,
           thing_roles_iter_res: nil,
           type_attributes_iter_res: nil,
           type_instances_iter_res: nil,
           type_keys_iter_res: nil,
           type_playing_iter_res: nil
         }}
      ) do
    attribute
  end

  def unwrap(
        {:conceptMethod_iter_res,
         %Session.Method.Iter.Res{
           attribute_owners_iter_res: nil,
           relationType_roles_iter_res: nil,
           relation_rolePlayersMap_iter_res: nil,
           relation_rolePlayers_iter_res: nil,
           role_players_iter_res: nil,
           role_relations_iter_res: nil,
           schemaConcept_subs_iter_res: nil,
           schemaConcept_sups_iter_res: nil,
           thing_attributes_iter_res: nil,
           thing_keys_iter_res: nil,
           thing_relations_iter_res: nil,
           thing_roles_iter_res: nil,
           type_attributes_iter_res: %Session.Type.Attributes.Iter.Res{
             attributeType: attribute_type
           },
           type_instances_iter_res: nil,
           type_keys_iter_res: nil,
           type_playing_iter_res: nil
         }}
      ) do
    attribute_type
  end

  def unwrap({:query_iter_res, %{answer: %{answer: answer}}}),
    do: unwrap(answer)

  def unwrap(
        {:getSchemaConcept_res,
         %Session.Transaction.GetSchemaConcept.Res{
           res: {:schemaConcept, schema_concept}
         }}
      ),
      do: schema_concept
end

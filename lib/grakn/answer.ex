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
      ) do
    value
  end
end

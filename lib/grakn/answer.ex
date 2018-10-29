defmodule Grakn.Answer do

  def unwrap({:value, %Session.Value{number: %Session.Number{value: value}}}) when is_binary(value) do
    if String.match?(value, ~r/\d+\.\d+/) do
      String.to_float(value)
    else
      String.to_integer(value)
    end
  end

  def unwrap({:conceptMap, %Session.ConceptMap{map: map}}), do: map

end

defmodule Grakn.Graql do
  @moduledoc false

  alias Grakn.Query

  defmodule Datatypes do
    @moduledoc false

    defstruct string: :string,
              long: :long,
              double: :double,
              boolean: :boolean,
              date: :date
  end

  defmacro __using__([]) do
    quote do
      import Grakn.Graql
    end
  end

  def datatypes, do: %Datatypes{}

  defmacro defpattern("$" <> var, isa: entity_type) do
    quote do
      Query.graql("$#{unquote(var)} isa #{unquote(entity_type)};")
    end
  end

  defmacro defpattern("$" <> var, isa: entity_type, has: attributes) do
    quote do
      Query.graql(
        "$#{unquote(var)} isa #{unquote(entity_type)} #{unquote(expand_key_values(attributes))};"
      )
    end
  end

  defmacro defschema(label, [sub: :entity] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: :entity, has: _] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: :entity, plays: _] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: :entity, has: _, plays: _] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: :entity, plays: _, has: _] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: :attribute, datatype: _] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: :attribute, datatype: _, plays: _] = opts),
    do: define_body(label, opts)

  defmacro defschema(label, [sub: :attribute, plays: _, datatype: _] = opts),
    do: define_body(label, opts)

  defmacro defschema(label, [sub: :relationship, relates: _] = opts), do: define_body(label, opts)

  defmacro defschema(label, [sub: :relationship, relates: _, has: _] = opts),
    do: define_body(label, opts)

  defmacro defschema(label, [sub: :relationship, relates: _, plays: _] = opts),
    do: define_body(label, opts)

  defmacro defschema(label, [sub: :relationship, relates: _, has: _, plays: _] = opts),
    do: define_body(label, opts)

  defmacro defschema(label, [sub: :relationship, relates: _, plays: _, has: _] = opts),
    do: define_body(label, opts)

  # Rules
  defmacro defschema(label, [sub: :rule, when: body, then: head] = opts) do
    body_patterns =
      body
      |> List.wrap()
      |> Enum.map(fn
        %Grakn.Query{graql: pattern} -> pattern
        string_pattern when is_bitstring(string_pattern) -> string_pattern
        _ -> error(label, opts)
      end)

    head_patterns =
      head
      |> case do
        %Grakn.Query{graql: pattern} -> pattern
        string_pattern when is_bitstring(string_pattern) -> string_pattern
        _ -> error(label, opts)
      end

    modified_opts = [sub: :rule, when: body_patterns, then: head_patterns]

    quote do
      define(unquote(label), unquote(modified_opts))
    end
  end

  # Allow any arbitrary sub types
  defmacro defschema(label, [sub: _type] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: _type, has: _] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: _type, plays: _] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: _type, has: _, plays: _] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: _type, plays: _, has: _] = opts), do: define_body(label, opts)
  defmacro defschema(label, [sub: _type, relates: _] = opts), do: define_body(label, opts)

  defmacro defschema(label, opts), do: error(label, opts)

  defp error(label, opts), do: raise("Graql compile error: #{inspect({label, opts})}")

  defp define_body(label, opts) do
    quote do
      define(unquote(label), unquote(opts))
    end
  end

  @spec define(String.t(), keyword()) :: Grakn.Query.t()
  def define(label, opts) do
    modifiers =
      opts
      |> Enum.map(&expand_key_values/1)
      |> Enum.join(", ")

    Query.graql("define #{label} #{modifiers};")
  end

  def expand_key_values({key, [_ | _] = values}) do
    case key do
      rule_key when rule_key in [:when, :then] ->
        statements =
          values
          |> List.wrap()
          |> Enum.join("; ")

        "#{rule_key} { #{statements}; }"

      _ ->
        values
        |> Enum.map(fn value -> "#{key} #{value}" end)
        |> Enum.join(", ")
    end
  end

  def expand_key_values({:then, value}), do: "then { #{value}; }"

  def expand_key_values({key, value}), do: "#{key} #{value}"
end

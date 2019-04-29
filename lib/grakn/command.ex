defmodule Grakn.Command do
  @moduledoc false

  @type command :: :get_keyspaces | :create_keyspace | :delete_keyspace
  @type t :: %__MODULE__{command: command(), params: keyword()}

  defstruct [:command, :params]

  @spec get_keyspaces() :: t()
  def get_keyspaces(), do: %__MODULE__{command: :get_keyspaces, params: []}

  @spec create_keyspace(String.t()) :: t()
  def create_keyspace(name), do: %__MODULE__{command: :create_keyspace, params: [name: name]}

  @spec delete_keyspace(String.t()) :: t()
  def delete_keyspace(name), do: %__MODULE__{command: :delete_keyspace, params: [name: name]}
end

defimpl DBConnection.Query, for: Grakn.Command do
  def parse(command, params) when is_binary(command) do
    %Grakn.Command{command: command, params: params}
  end

  def parse(query, _opts), do: query
  def describe(query, _opts), do: query
  def encode(_query, params, _opts), do: params
  def decode(_query, result, _opts), do: result
end

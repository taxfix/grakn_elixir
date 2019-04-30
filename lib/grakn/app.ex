defmodule Grakn.App do
  @moduledoc false

  use Application

  alias Grakn.Cache

  def start(_type, _opts) do
    children = [Cache, Cache.Janitor]
    Supervisor.start_link(children, strategy: :rest_for_one)
  end
end

# Grakn Elixir client

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `grakn_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:grakn_elixir, "~> 0.1.0"}
  ]
end
```

## Configuration

We can specify hostname, pool_size and if needed we can specify the credentials [as per documentation in grakn.ai](http://dev.grakn.ai/docs/management/users#managing-users-kgms-only)

```elixir
config :grakn_elixir,
  hostname: "localhost",
  username: "username",
  password: "password",
  pool_size: 4
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/grakn_elixir](https://hexdocs.pm/grakn_elixir).


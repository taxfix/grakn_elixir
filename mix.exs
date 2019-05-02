defmodule GraknElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :grakn_elixir,
      version: "0.2.0-dev",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_file: {:no_warn, ".dialyzer/local.plt"}]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Grakn.App, []},
      env: [session_ttl_interval: 5_000, session_ttl: 30_000]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cachex, "~> 3.1.0"},
      {:db_connection, "~> 1.1.0"},
      {:poolboy, "~> 1.5.1"},
      {:grpc, "~> 0.3.1"},
      {:protobuf, "~> 0.5.3"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:benchee, "~> 0.13", only: :dev}
    ]
  end
end

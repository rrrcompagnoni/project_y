defmodule ProjectY.MixProject do
  use Mix.Project

  def project do
    [
      app: :project_y,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {ProjectY.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_uuid, "~> 1.2"},
      {:swarm, "~> 3.0"},
      {:libcluster, "~> 3.2.1"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end

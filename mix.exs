defmodule EverylogElixirClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :everylog_elixir_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      authors: [{"David Gasana Manzi", "david.gasana@devinterface"}]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:poison, "~> 3.1"}
    ]
  end

end

defmodule SpandexOTLP.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "#TODO"

  def project do
    [
      app: :spandex_otlp,
      description:
        "An adapter for Spandex that allows the export of tracing data to an OTLP compatible service.",
      version: @version,
      elixir: "~> 1.11.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp package do
    [
      name: :spandex_otlp,
      maintainers: ["John Doneth"],
      licenses: ["MIT License"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: @version,
      extras: ["README.md"]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:grpc, github: "elixir-grpc/grpc"},
      {:gun, "~> 2.0.0", hex: :grpc_gun, override: true},
      {:spandex, "~> 3.0"},
      {:telemetry, "~> 0.4"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14", only: [:test]}
    ]
  end
end

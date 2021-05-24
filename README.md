# SpandexOTLP

[![Elixir](https://github.com/JohnDoneth/spandex_otlp/actions/workflows/elixir.yaml/badge.svg)](https://github.com/JohnDoneth/spandex_otlp/actions/workflows/elixir.yaml)
[![codecov](https://codecov.io/gh/JohnDoneth/spandex_otlp/branch/main/graph/badge.svg?token=7Q67PHA3MW)](https://codecov.io/gh/JohnDoneth/spandex_otlp)

A [OpenTelemetry Protocol](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/protocol/README.md) adapter for the [Spandex](https://github.com/spandex-project/spandex) library.

## Installation

Add `spandex_otlp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spandex_otlp, "~> 0.1.0-rc.2"}
  ]
end
```

## Getting Started

You must first follow the steps in the Spandex guide to get Spandex setup while substituting `SpandexOTLP.Adapter` for `SpandexDatadog.Adapter`.

```elixir
config :my_app, MyApp.Tracer,
  adapter: SpandexOTLP.Adapter
```

Then make the following changes to your `config.exs` to configure this adapter.

```elixir
config :spandex_otlp, SpandexOTLP,
  otp_app: :my_app,
  endpoint: "<host:port>",
  ca_cert_file: "./tls/ca.pem", # Path to your PEM file in your priv directory. Only if you plan on using HTTPS.
  headers: %{},
  resources: %{
    "service.name" => "<Your Service Name>",
    "service.namespace" => "<Your Service Namespace>"
  }
```

Then add `SpandexOTLP.Sender` to your application supervision tree.

```elixir
children = [
  SpandexOTLP.Sender
]
```

### Configuring for Lightstep

If you plan on using [Lightstep](https://lightstep.com/) with this adapter. You can follow this example config to get started.

```elixir
config :spandex_otlp, SpandexOTLP,
  otp_app: :my_app,
  endpoint: "ingest.lightstep.com:443",
  ca_cert_file: "./tls/ca.pem", # It's required to use HTTPS with Lightstep
  headers: %{
    "lightstep-access-token": "<your lightstep access token>"
  },
  resources: %{
    "service.name" => "<Your Service Name>", # Required by Lightstep
    "service.namespace" => "<Your Service Namespace>" # Required by Lightstep
  }
```

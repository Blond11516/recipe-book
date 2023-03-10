import Config

RecipeBookConfig.load_env()

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/recipe_book start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if RecipeBookConfig.phx_server() do
  config :recipe_book, RecipeBookWeb.Endpoint, server: true
end

if RecipeBookConfig.debug_opentelemetry?() do
  config :opentelemetry, :processors,
    otel_batch_processor: %{
      exporter: {:otel_exporter_stdout, []}
    }
else
  config :opentelemetry,
         :tracer,
         :otel_tracer_noop
end

config :recipe_book, RecipeBook.Repo, database: RecipeBookConfig.database_path()

if config_env() == :prod do
  config :recipe_book, RecipeBook.Repo,
    # ssl: true,
    pool_size: RecipeBookConfig.pool_size()

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base = RecipeBookConfig.secret_key_base()

  host = RecipeBookConfig.phx_host()
  port = RecipeBookConfig.port()

  config :recipe_book, RecipeBookWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  config :opentelemetry,
    span_processor: :batch,
    exporter: :otlp

  config :opentelemetry_exporter,
    otlp_protocol: :http_protobuf,
    otlp_traces_endpoint: "https://ingest.lightstep.com:443/traces/otlp/v0.9",
    otlp_compression: :gzip,
    otlp_headers: [
      {"lightstep-access-token", RecipeBookConfig.lightstep_access_token()}
    ]
end

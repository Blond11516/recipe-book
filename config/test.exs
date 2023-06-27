import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :recipe_book, RecipeBook.Repo, pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :recipe_book, RecipeBookWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "NXvg7KiQaYnZePgbozlpN445Y6863mVIFyLZ1tk5a2ayC+BZoBYZbzIoeFE87rhH",
  server: false

# In test we don't send emails.
config :recipe_book, RecipeBook.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

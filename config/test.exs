import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :hesed, Hesed.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "hesed_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :bcrypt_elixir, log_rounds: 4

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hesed, HesedWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "fFI57y1megIK15x9e8ErmnGG7bp50M9rXm+1g0R25c5OLKSd0+179szY3r5qkp6d",
  server: false

# In test we don't send emails.
config :hesed, Hesed.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

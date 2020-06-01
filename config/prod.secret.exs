# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

database_url =
  System.get_env("DATABASE_URL") || "ecto://postgres:postgres@localhost/time_tracker_prod"

config :time_tracker, TimeTracker.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    "orZ2F1SYzXCizzfWcKShwU270vVbVfCeHpNVq8kDIrlBq2ICeYSd3StV2QBPbwX+"

config :time_tracker, TimeTrackerWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :time_tracker, TimeTrackerWeb.Endpoint, server: true

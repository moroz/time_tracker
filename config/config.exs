# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :time_tracker,
  ecto_repos: [TimeTracker.Repo]

# Configures the endpoint
config :time_tracker, TimeTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zfIxZzgXYeTtLOQmc2MIChmJ/4Nt/sF0HI/fMSQHlxL+cDjfuwb7jmrZ5AxXmSmt",
  render_errors: [view: TimeTrackerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TimeTracker.PubSub,
  live_view: [signing_salt: "YpUREx7z"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine

config :phoenix_slime, :use_slim_extension, true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

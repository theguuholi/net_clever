# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :net_clever,
  ecto_repos: [NetClever.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :net_clever, NetCleverWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YES1vWc5mUYOg2seS8G72JhFu1x/qCyUTUVRi4O6lLjNeurPid3PcPqSWMjx8aq1",
  render_errors: [view: NetCleverWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NetClever.PubSub,
  live_view: [signing_salt: "K+sTeT03"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

import Config

config :datastore,
  port: 8887,
  example: "This config is set at compile-time"

IO.puts("config.exs is processed")

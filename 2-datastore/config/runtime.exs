import Config

config :datastore,
  port: String.to_integer(System.get_env("PORT") || "8888"),
  example: "This config is set at runtime"

IO.puts("runtime.exs is processed")

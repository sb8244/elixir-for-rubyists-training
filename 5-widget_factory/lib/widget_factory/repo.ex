defmodule WidgetFactory.Repo do
  use Ecto.Repo,
    otp_app: :widget_factory,
    adapter: Ecto.Adapters.Postgres
end

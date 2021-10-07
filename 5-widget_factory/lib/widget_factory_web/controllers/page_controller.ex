defmodule WidgetFactoryWeb.PageController do
  use WidgetFactoryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

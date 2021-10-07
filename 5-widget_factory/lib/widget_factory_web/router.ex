defmodule WidgetFactoryWeb.Router do
  use WidgetFactoryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WidgetFactoryWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WidgetFactoryWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/widgets", WidgetLive.Index, :index
    live "/widgets/new", WidgetLive.Index, :new
    live "/widgets/:id/edit", WidgetLive.Index, :edit

    live "/widgets/:id", WidgetLive.Show, :show
    live "/widgets/:id/show/edit", WidgetLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", WidgetFactoryWeb do
  #   pipe_through :api
  # end
end

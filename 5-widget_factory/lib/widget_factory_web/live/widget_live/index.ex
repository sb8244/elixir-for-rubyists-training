defmodule WidgetFactoryWeb.WidgetLive.Index do
  use WidgetFactoryWeb, :live_view

  alias WidgetFactory.Widgets
  alias WidgetFactory.Widgets.Widget

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      WidgetFactoryWeb.Endpoint.subscribe("widgets:add")
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign(widgets: list_widgets(params))
      |> assign(params: params)
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Widget")
    |> assign(:widget, Widgets.get_widget!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Widget")
    |> assign(:widget, %Widget{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Widgets")
    |> assign(:widget, nil)
  end

  def handle_info(%{event: "add", topic: "widgets:add"}, socket = %{assigns: %{params: params}}) do
    # TODO: Challenge, can you make it live-update without hitting the database?
    {:noreply, assign(socket, :widgets, list_widgets(params))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    widget = Widgets.get_widget!(id)
    {:ok, _} = Widgets.delete_widget(widget)

    {:noreply, assign(socket, :widgets, list_widgets(socket.assigns.params))}
  end

  @impl true
  def handle_event("filters.type", %{"type" => type}, socket) do
    params =
      case type do
        "" -> %{}
        type -> %{type: type}
      end

    {:noreply, push_patch(socket, to: Routes.widget_index_path(socket, :index, params))}
  end

  defp list_widgets(params) do
    _filters = Map.take(params, ["type"])
    # Use filters to list the widgets of a given type
    Widgets.list_widgets()
  end
end

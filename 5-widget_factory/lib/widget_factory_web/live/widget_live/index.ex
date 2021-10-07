defmodule WidgetFactoryWeb.WidgetLive.Index do
  use WidgetFactoryWeb, :live_view

  alias WidgetFactory.Widgets
  alias WidgetFactory.Widgets.Widget

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :widgets, list_widgets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    widget = Widgets.get_widget!(id)
    {:ok, _} = Widgets.delete_widget(widget)

    {:noreply, assign(socket, :widgets, list_widgets())}
  end

  defp list_widgets do
    Widgets.list_widgets()
  end
end

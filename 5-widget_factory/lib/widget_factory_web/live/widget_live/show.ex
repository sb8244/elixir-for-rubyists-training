defmodule WidgetFactoryWeb.WidgetLive.Show do
  use WidgetFactoryWeb, :live_view

  alias WidgetFactory.Widgets

  def render(assigns) do
  ~H"""
    <h1>Show Widget</h1>

    <%= if @live_action in [:edit] do %>
      <%= live_modal WidgetFactoryWeb.WidgetLive.FormComponent,
        id: @widget.id,
        title: @page_title,
        action: @live_action,
        widget: @widget,
        return_to: Routes.widget_show_path(@socket, :show, @widget) %>
    <% end %>

    <ul>

      <li>
        <strong>Name:</strong>
        <%= @widget.name %>
      </li>

      <li>
        <strong>Type:</strong>
        <%= @widget.type %>
      </li>

    </ul>

    <span><%= live_patch "Edit", to: Routes.widget_show_path(@socket, :edit, @widget), class: "button" %></span> |
    <span><%= live_redirect "Back", to: Routes.widget_index_path(@socket, :index) %></span>
  """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:widget, Widgets.get_widget!(id))}
  end

  defp page_title(:show), do: "Show Widget"
  defp page_title(:edit), do: "Edit Widget"
end

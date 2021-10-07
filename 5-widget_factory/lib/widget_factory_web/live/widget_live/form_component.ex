defmodule WidgetFactoryWeb.WidgetLive.FormComponent do
  use WidgetFactoryWeb, :live_component

  alias WidgetFactory.Widgets

  @impl true
  def update(%{widget: widget} = assigns, socket) do
    changeset = Widgets.change_widget(widget)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"widget" => widget_params}, socket) do
    changeset =
      socket.assigns.widget
      |> Widgets.change_widget(widget_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"widget" => widget_params}, socket) do
    save_widget(socket, socket.assigns.action, widget_params)
  end

  defp save_widget(socket, :edit, widget_params) do
    case Widgets.update_widget(socket.assigns.widget, widget_params) do
      {:ok, _widget} ->
        {:noreply,
         socket
         |> put_flash(:info, "Widget updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_widget(socket, :new, widget_params) do
    case Widgets.create_widget(widget_params) do
      {:ok, _widget} ->
        {:noreply,
         socket
         |> put_flash(:info, "Widget created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

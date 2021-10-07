defmodule WidgetFactory.WidgetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WidgetFactory.Widgets` context.
  """

  @doc """
  Generate a widget.
  """
  def widget_fixture(attrs \\ %{}) do
    {:ok, widget} =
      attrs
      |> Enum.into(%{
        name: "some name",
        type: "some type"
      })
      |> WidgetFactory.Widgets.create_widget()

    widget
  end
end

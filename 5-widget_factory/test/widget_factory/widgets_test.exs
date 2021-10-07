defmodule WidgetFactory.WidgetsTest do
  use WidgetFactory.DataCase

  alias WidgetFactory.Widgets

  describe "widgets" do
    alias WidgetFactory.Widgets.Widget

    import WidgetFactory.WidgetsFixtures

    @invalid_attrs %{name: nil, type: nil}

    test "list_widgets/0 returns all widgets" do
      widget = widget_fixture()
      assert Widgets.list_widgets() == [widget]
    end

    test "get_widget!/1 returns the widget with given id" do
      widget = widget_fixture()
      assert Widgets.get_widget!(widget.id) == widget
    end

    test "create_widget/1 with valid data creates a widget" do
      valid_attrs = %{name: "some name", type: "some type"}

      assert {:ok, %Widget{} = widget} = Widgets.create_widget(valid_attrs)
      assert widget.name == "some name"
      assert widget.type == "some type"
    end

    test "create_widget/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Widgets.create_widget(@invalid_attrs)
    end

    test "update_widget/2 with valid data updates the widget" do
      widget = widget_fixture()
      update_attrs = %{name: "some updated name", type: "some updated type"}

      assert {:ok, %Widget{} = widget} = Widgets.update_widget(widget, update_attrs)
      assert widget.name == "some updated name"
      assert widget.type == "some updated type"
    end

    test "update_widget/2 with invalid data returns error changeset" do
      widget = widget_fixture()
      assert {:error, %Ecto.Changeset{}} = Widgets.update_widget(widget, @invalid_attrs)
      assert widget == Widgets.get_widget!(widget.id)
    end

    test "delete_widget/1 deletes the widget" do
      widget = widget_fixture()
      assert {:ok, %Widget{}} = Widgets.delete_widget(widget)
      assert_raise Ecto.NoResultsError, fn -> Widgets.get_widget!(widget.id) end
    end

    test "change_widget/1 returns a widget changeset" do
      widget = widget_fixture()
      assert %Ecto.Changeset{} = Widgets.change_widget(widget)
    end
  end
end

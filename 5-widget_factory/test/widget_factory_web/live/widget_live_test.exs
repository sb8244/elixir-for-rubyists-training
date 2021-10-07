defmodule WidgetFactoryWeb.WidgetLiveTest do
  use WidgetFactoryWeb.ConnCase

  import Phoenix.LiveViewTest
  import WidgetFactory.WidgetsFixtures

  @create_attrs %{name: "some name", type: "some type"}
  @update_attrs %{name: "some updated name", type: "some updated type"}
  @invalid_attrs %{name: nil, type: nil}

  defp create_widget(_) do
    widget = widget_fixture()
    %{widget: widget}
  end

  describe "Index" do
    setup [:create_widget]

    test "lists all widgets", %{conn: conn, widget: widget} do
      {:ok, _index_live, html} = live(conn, Routes.widget_index_path(conn, :index))

      assert html =~ "Listing Widgets"
      assert html =~ widget.name
    end

    test "saves new widget", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.widget_index_path(conn, :index))

      assert index_live |> element("a", "New Widget") |> render_click() =~
               "New Widget"

      assert_patch(index_live, Routes.widget_index_path(conn, :new))

      assert index_live
             |> form("#widget-form", widget: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#widget-form", widget: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.widget_index_path(conn, :index))

      assert html =~ "Widget created successfully"
      assert html =~ "some name"
    end

    test "updates widget in listing", %{conn: conn, widget: widget} do
      {:ok, index_live, _html} = live(conn, Routes.widget_index_path(conn, :index))

      assert index_live |> element("#widget-#{widget.id} a", "Edit") |> render_click() =~
               "Edit Widget"

      assert_patch(index_live, Routes.widget_index_path(conn, :edit, widget))

      assert index_live
             |> form("#widget-form", widget: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#widget-form", widget: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.widget_index_path(conn, :index))

      assert html =~ "Widget updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes widget in listing", %{conn: conn, widget: widget} do
      {:ok, index_live, _html} = live(conn, Routes.widget_index_path(conn, :index))

      assert index_live |> element("#widget-#{widget.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#widget-#{widget.id}")
    end
  end

  describe "Show" do
    setup [:create_widget]

    test "displays widget", %{conn: conn, widget: widget} do
      {:ok, _show_live, html} = live(conn, Routes.widget_show_path(conn, :show, widget))

      assert html =~ "Show Widget"
      assert html =~ widget.name
    end

    test "updates widget within modal", %{conn: conn, widget: widget} do
      {:ok, show_live, _html} = live(conn, Routes.widget_show_path(conn, :show, widget))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Widget"

      assert_patch(show_live, Routes.widget_show_path(conn, :edit, widget))

      assert show_live
             |> form("#widget-form", widget: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#widget-form", widget: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.widget_show_path(conn, :show, widget))

      assert html =~ "Widget updated successfully"
      assert html =~ "some updated name"
    end
  end
end

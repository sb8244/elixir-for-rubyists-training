defmodule WidgetFactory.Widgets do
  @moduledoc """
  The Widgets context.
  """

  import Ecto.Query, warn: false
  alias WidgetFactory.Repo

  alias WidgetFactory.Widgets.Widget

  @doc """
  Returns the list of widgets.

  ## Examples

      iex> list_widgets()
      [%Widget{}, ...]

  """
  def list_widgets() do
    from(
      w in Widget,
      order_by: [desc: w.id]
    )
    |> Repo.all()
  end

  @doc """
  List widgets with filters applied. The filters are built up dynamically using
  functions. This is a great thing about Elixir / Ecto.Query, you can generally build
  up data-structures over time and then apply them in the future.
  """
  def solution_list_widgets(params) do
    query =
      from(
        w in Widget,
        order_by: [desc: w.id]
      )
      |> solution_add_type(params)

    Repo.all(query)
  end

  defp solution_add_type(query, %{"type" => type}) do
    where(query, [w], w.type == ^type)
  end

  defp solution_add_type(query, _), do: query

  @doc """
  Gets a single widget.

  Raises `Ecto.NoResultsError` if the Widget does not exist.

  ## Examples

      iex> get_widget!(123)
      %Widget{}

      iex> get_widget!(456)
      ** (Ecto.NoResultsError)

  """
  def get_widget!(id), do: Repo.get!(Widget, id)

  @doc """
  Creates a widget.

  ## Examples

      iex> create_widget(%{field: value})
      {:ok, %Widget{}}

      iex> create_widget(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_widget(attrs \\ %{}) do
    %Widget{}
    |> Widget.changeset(attrs)
    |> Repo.insert()
    |> maybe_broadcast()
  end

  @doc """
  Updates a widget.

  ## Examples

      iex> update_widget(widget, %{field: new_value})
      {:ok, %Widget{}}

      iex> update_widget(widget, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_widget(%Widget{} = widget, attrs) do
    widget
    |> Widget.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a widget.

  ## Examples

      iex> delete_widget(widget)
      {:ok, %Widget{}}

      iex> delete_widget(widget)
      {:error, %Ecto.Changeset{}}

  """
  def delete_widget(%Widget{} = widget) do
    Repo.delete(widget)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking widget changes.

  ## Examples

      iex> change_widget(widget)
      %Ecto.Changeset{data: %Widget{}}

  """
  def change_widget(%Widget{} = widget, attrs \\ %{}) do
    Widget.changeset(widget, attrs)
  end

  defp maybe_broadcast(ret = {:ok, widget}) do
    # TODO: Broadcast an event that's consumed in `WidgetLive.Index`
    ret
  end

  defp maybe_broadcast(ret), do: ret
end

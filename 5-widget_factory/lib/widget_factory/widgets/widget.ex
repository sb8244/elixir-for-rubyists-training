defmodule WidgetFactory.Widgets.Widget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "widgets" do
    field :name, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(widget, attrs) do
    widget
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
  end
end

# Ecto and LiveView Example: Widget Factory

This repo is a very basic CRUD interface for managing Widgets. Essentially, the
phoenix generators were used to create the repository and the Widget codebase.
In this example, we're going to be exploring what's available to us, and then add
some additional functionality to it.

Follow along and complete the challenges as you go. Solutions are at the bottom
if you get stuck, but please ask questions as needed.

## Installation

* `mix deps.get`
* `mix ecto.setup`

## Making Changes

After you make a change, you can type `recompile` to cause all files to be compiled and reloaded.

## Part 1: Playing with Ecto

The purpose of this first exercise is to get some experience with Ecto. We'll cover how
to use changesets to create / update data and how to query for that data.

### Changesets

Changesets are a bit of a foreign concept at first. In ActiveRecord, you simply operate on
the object to make changes. For example:

```ruby
Widget.new(name: "Doohickie", type: "important") # doesn't go to database
widget = Widget.create(name: "Doohickie", type: "important") # Goes to database

widget.type = "not important" # Not database
widget.save! # Goes to database
widget.update!(type: "very_important") # Goes to database
```

ActiveRecord combines operations (create, update, relationships) onto the object itself. The
meta operations like listing records, creation, etc. is done on the class for the object type.
This is very easy to use and understand, but create a complexity in knowing when something will
hit the database.

Let's see how we'd do that with Ecto. Open a terminal with `iex -S mix`

```elixir
> iex -S mix

iex> alias WidgetFactory.Widgets.Widget
iex> Widget.changeset(%Widget{}, %{})
```

You'll see an Ecto.Changeset struct printed out to your screen. There are validation errors present
because we haven't put actual data in. Let's fix that:

```elixir
iex> Widget.changeset(%Widget{}, %{name: "Doohickie", type: "important"})
```

You will see that the new changeset is valid, and the changes are visible in it. Throughout this, there
have been no database calls. The changeset is functional and is kept away from the database. Look at the
`lib/widget_factory/widgets/widget.ex` file to see how the changeset is defined.

You typically keep your entire changeset pipeline in the schema file. This creates simplicity and gives
a central point of understanding. You can have different changeset functions, like `changeset/1` versus
`update_changeset/2`. Our example sticks with one.

Use the [Changeset docs](https://hexdocs.pm/ecto/Ecto.Changeset.html) to learn about the function that
allows us to validate `type` is one of `["important", "standard", "custom"]`. Add it to the `changeset/2`
function so that the following changeset is not valid.

```elixir
iex> Widget.changeset(%Widget{}, %{name: "Doohickie", type: "invalid"})
```

### Saving a Changeset

A changeset represents the data that we'd like to insert / update, and gives a way to validate it. But,
how do we actually save it?

There are two distinct modes that a changeset can operate in. The first is one that you've already seen:
*insert mode*. In this mode, there is no underlying data. We passed in `%Widget{}` to express this. The second
mode is *update mode*. In this mode, you provide the changeset with existing data and what you'd like to
change. We'll see an example of this soon.

In your iex session, we're going to save a widget:

```elixir
iex> cs = Widget.changeset(%Widget{}, %{name: "Doohickie", type: "important"})
iex> widget = WidgetFactory.Repo.insert!(cs)
```

You have a widget now! It is very clear where the boundary between database and functional code is, because
you have to invoke a `Repo` function to interact with the database. This is a "gateway pattern" and it creates
a convenient choke point in an application for all data updates to go through.

Let's see an example of updating a widget:

```elixir
# Your TODO: Make this next line work
iex> update_cs = Widget.changeset(XXX, %{name: "updated"})
iex> widget = WidgetFactory.Repo.update!(update_cs)
```

What happens if you accidentally mix up these functions? Try to call `update!(cs)` and `insert!(update_cs)`
to see what happens.

Finally, let's create a bunch of widgets for our next section:

```elixir
iex> for i <- 1..100 do
  cs = Widget.changeset(%Widget{}, %{name: "Widget #{i}", type: Enum.random(["important", "standard", "custom"])})
  WidgetFactory.Repo.insert!(cs)
end
```

### Ecto Queries

[Repo](https://hexdocs.pm/ecto/Ecto.Repo.html) provides several functions for querying data. If you get stuck
on anything in the next section, make sure to read the corresponding documentation for the function.

Some queries are very simple, such as getting a record by its ID:

```elixir
iex> WidgetFactory.Repo.get(Widget, 1)
```

Others may requiring passing in a set of key-values that we want to query for:

```elixir
iex> WidgetFactory.Repo.get_by(Widget, name: "updated")
```

This is very straightforward, but honestly not quite that common. In practice, you'll be doing more complex
queries, joins, filters, etc. For that, there's `Ecto.Query`. You'll often see this `import`ed at the top
of a file, because it allows for a very simple query DSL that way.

```elixir
iex> import Ecto.Query
iex> query = (from w in Widget)
iex> WidgetFactory.Repo.all(query)
```

Can you write a more complex query? Create a query that retrieves all "important" widgets. Read
the Ecto.Query documentation to figure out what you need.

Take the same query and use `Repo.aggregate/2` to get the count of important widgets.

### Trying it out

Run your app with `iex -S mix phx.server` and load http://localhost:4000/widgets in your browser.
You will see a list of all of your widgets. You can create, edit, delete, etc.

The filters at the top are left as an exercise for you. You'll see that clicking them changes the
URL, but nothing happens. Follow the `Index` LiveView and create a query that applies the filters.

The solution for this is included in the source code, so you can see what to do if you get stuck.

## Part 2: Real-time Data Updates

## Running

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Solutions

### A

To validate `type` being a certain value, add the following line to the end of `changeset/2`.

```
validate_inclusion(:type, ["important", "standard", "custom"])
```

### B

To update the widget, use:

```
update_cs = Widget.changeset(widget, %{name: "updated"})
```

### C

To query for important widgets:

```elixir
iex> query = (from w in Widget, where: w.type == "important")
iex> all = WidgetFactory.Repo.all(query)
iex> length(all)
```

You can also build up a query in multiple steps, like so:

```elixir
iex> query = (from w in Widget)
iex> query = query |> where([w], w.type == "important")
iex> WidgetFactory.Repo.all(query)
```

This is very useful for building up complex queries that have conditionally applied clauses.

### D

See `Widgets.solution_list_widgets/1` to see how filters can be applied to the query.

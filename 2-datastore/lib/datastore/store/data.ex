defmodule Datastore.Store.Data do
  @moduledoc """
  The data store is implemented in-memory via a GenServer.

  What are the disadvantages to this single GenServer approach?

  * Only 1 command to the store can be processed at a time. It is possible to experience
    a slower store if tons of commands are sent simultaneously via multiple clients.
  """

  use GenServer

  def get(k, pid \\ __MODULE__) do
    GenServer.call(pid, {:get, k})
  end

  def put(k, v, pid \\ __MODULE__) do
    GenServer.call(pid, {:put, k, v})
  end

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:put, k, v}, _from, state) do
    next_state = Map.put(state, k, v)
    reply = {k, v}

    {:reply, reply, next_state}
  end

  def handle_call({:get, k}, _from, state) do
    reply =
      case Map.fetch(state, k) do
        {:ok, value} -> {k, value}
        :error -> :error
      end

    {:reply, reply, state}
  end
end

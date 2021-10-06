defmodule Datastore.Store.Connection do
  @moduledoc """
  Each connection to a client is a separate process. Any crashes are kept isolated as to not
  affect one another.

  Most commonly, you might use a DynamicSupervisor or TaskSupervisor to implement this pattern.
  However, we're using spawn/receive to get an example of the underlying process primitive. But,
  spawn/receive is totally valid as well.
  """

  require Logger
  alias Datastore.Store.Data

  def assume_tcp_connection(socket) do
    pid = spawn(__MODULE__, :client_receive, [])
    :ok = :gen_tcp.controlling_process(socket, pid)
  end

  def client_receive do
    next =
      receive do
        {:tcp, socket, packet} ->
          command = packet |> String.trim() |> String.split(" ", parts: 3)
          command(command, socket)
          :loop

        {:tcp_closed, _socket} ->
          Logger.info("Client closed")
          :close

        {:tcp_error, _socket, reason} ->
          Logger.error("Client error: #{reason}")
          :close
      end

    case next do
      :loop -> client_receive()
      :close -> :done
    end
  end

  defp command(["GET", key], socket) do
    case Data.get(key) do
      {^key, value} ->
        :gen_tcp.send(socket, "#{value}\n")

      _ ->
        :gen_tcp.send(socket, "NOT SET\n")
    end
  end

  defp command(["PUT", key, value], socket) do
    {^key, ^value} = Data.put(key, value)
    :gen_tcp.send(socket, "OK\n")
  end

  # Looking for a challenge? Implement `DELETE key` and `KEYS` commands

  defp command(_, socket) do
    :gen_tcp.send(socket, "UNKNOWN\n")
  end
end

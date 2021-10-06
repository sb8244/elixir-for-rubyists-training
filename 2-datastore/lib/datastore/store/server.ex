defmodule Datastore.Store.Server do
  @moduledoc """
  This GenServer listens for TCP connections and passes off connections for further processing.
  """

  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  IO.puts("""
  #{__MODULE__} code executing outside of a function. The port env is:

  #{inspect(Application.get_env(:datastore, :port))}

  Note which port the app starts on. Is it the same or different?
  """)

  def init(_opts) do
    port = Application.get_env(:datastore, :port, 1337)

    case :gen_tcp.listen(port, [:binary, active: true]) do
      {:ok, socket} ->
        Logger.info("#{__MODULE__} started listening on #{port}")
        send(self(), :accept)
        {:ok, %{socket: socket}}

      {:error, :eaddrinuse} ->
        {:stop, "port #{port} already in use"}
    end
  end

  # This handle_info clause receives messages that were sent to this process. In this case, the process
  # is sending a message to itself. After the client is connected, the socket accepts more connections.
  def handle_info(:accept, state = %{socket: socket}) do
    {:ok, client} = :gen_tcp.accept(socket)
    :ok = Datastore.Store.Connection.assume_tcp_connection(client)

    Logger.info("Client connected")
    send(self(), :accept)

    {:noreply, state}
  end
end

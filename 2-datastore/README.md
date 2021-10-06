# Datastore

This example will walk you through generating a very basic release for a
pre-built Elixir application. This application is a key-value store that
listens on a provided port. The KV store responds to:

```
GET key
PUT key value
```

For example:

```
> GET test
NOT SET
> PUT test A Value
OK
> GET test
A Value
```

# 0. Install deps

```
mix deps.get
All dependencies are up to date
```

# 1. Run the program from command line

Start the program with `iex -S mix`

# 2. Note the startup port

A message will print to the screen when the app compiles. If you need to recompile it, you can run
`mix compile --force` to guarantee that it compiles.

Note the port that the message prints out.

You will then see a message like `Server started listening on...`. Note that port.

Are these ports the same or different? Read through the code in `server.ex`, `config.exs`,
and `runtime.exs` to see if you can spot what's happening.

# 3. Generate a release

Mix provides a handy [Mix.Release](https://hexdocs.pm/mix/1.12/Mix.Tasks.Release.html)
tool to bundle up your application. We'll talk about why this is important. For now, you
can generate a release with `MIX_ENV=prod mix release`.

# 4. Run the release

Start the release using the command provided in the release instruction:

```
_build/prod/rel/datastore/bin/datastore start
```

Note the port that it starts up on. You can change this port by prefixing the command
with a PORT env, like so:

```
PORT=1337 _build/prod/rel/datastore/bin/datastore start
```

See if you can find the place in the code that make this dynamic port work.

# 5. Try out the app

I am writing this on a mac, so the out-of-the-box tool for interacting with a TCP connection
is the `nc` program. You can start a connection like so:

```
nc localhost 8888
```

The program will send anything after a new line to the server. Here's an example session:

```
➜ nc localhost 8888
GET test
NOT SET
PUT test 1
OK
GET test
1
PUT test 2
OK
GET test
2
GE typo
UNKNOWN
```

# 6. Read the source

This application is daunting at a first glance. However, it becomes easier to quickly read once
you use Elixir more. For now, I would recommend the following order:

1. application.ex
2. data.ex
3. connection.ex
4. server.ex

There is some interesting stuff with TCP going on here, but the real meat is in the application
tree and the data GenServer.

# 7. Looking for a challenge? Implement `DELETE key` and `KEYS` commands

There is a placeholder for where you can implement these commands. It will involve modifying both
the data GenServer and the connection command function.

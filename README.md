# Docker Spigot Server
The simpelest of simple spigot servers - running small on alpine.

## Commands

### Running the server

 - REQUIRED: Mount /minecraft to a folder, like `-v $HOME/mc-server:/minecraft`
 - REQUIRED: You have to accept the EULA, see [Accepting the EULA](#accepting-the-eula)
 - OPTIONAL: Use your current user/group so you do not get permission errors, like `--user $(id -u):$(id -g)`
 - OPTIONAL: Use `-it` to be able to run commands as you would with a normal server

```bash
# EXAMPLE STARTUP COMMAND
docker run --rm -v $HOME/mc-server:/minecraft --user $(id -u):$(id -g) -it roboroads/spigot-server
```

> This command is probably all you need to quickstart. If spigot is non-existant yet it will build the latest version, if you havn't accepted Minecrafts EULA - it will help you doing that before starting.

### Updating spigot

 - REQUIRED: Mount /minecraft to a folder, like `-v $HOME/mc-server:/minecraft`
 - OPTIONAL: Select a specific version (used as --rev), like `-e SPIGOT_VERSION=1.16.1`
 
```bash
# EXAMPLE UPDATE COMMAND
docker run --rm -v $HOME/mc-server:/minecraft -e SPIGOT_VERSION=1.16.1 --user $(id -u):$(id -g) -it roboroads/spigot-server update
```

### Accepting the EULA
You need to accept the EULA. You can run the server once and edit the file yourself, or run the command vor running the server appended by "eula"

```bash
# EXAMPLE EULA COMMAND
docker run --rm -v $HOME/mc-server:/minecraft --user $(id -u):$(id -g) -it roboroads/spigot-server eula
```

### Using detached mode
Just use -d  - and give it a name so you can access it later with `--name`

```bash
# EXAMPLE DETACHED STARTUP COMMAND
docker run --rm -d --name spigot -v $HOME/mc-server:/minecraft --user $(id -u):$(id -g) -it roboroads/spigot-server
```

When needed to access the server, you can just attach back to it, and use `CTRL-p CTRL-q` to detach again.

```bash
# EXAMPLE ATTACH COMMAND
docker attach spigot
```

## Extra info

### Why build tools?
Because of Minecrafts EULA - I can't share a precompiled binary. But you can download the official binaries and compile spigot into it because that's not sharing a (modified) version of the binary.

It's also easier to update without me changing the docker file at all, so no wait for updates from me!

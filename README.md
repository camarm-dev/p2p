# Push to prod
Push 2 prod: the easiest and modern way to push any apps to production in one command.

## Table of content
- [What does p2p ?](#what-does-p2p-)
- [Documentation](#documentation)
  - [Install](#install)
  - [Add an host](#add-an-host)
  - [Write a configuration file](#write-a-configuration--p2p--file)
  - [Develop on p2p](#develop-on-p2p)
- [P2P Webui ?](#p2p-webui)

## What does p2p ?
P2p is a command line tool written in ruby that push any apps to production with a single configuration file and in one command.
It uses ssh and don't required any agent on the distant machine.

1. Add the distant machine using p2p and give it a name.
2. Write a config file named `.p2p` at your project root.
3. Execute `p2p -e` at your project root.

And your app is now running on your distant host !

# Documentation

## Install
You need
- openssh (clients & server)
- ping
- tar
- ruby

```shell
wget https://raw.githubusercontent.com/camarm-dev/p2p/main/install.sh | sudo sh
```

## Add an host
```shell
p2p servers add
```
Follow the wizard...

## Write a configuration (.p2p) file
P2P as his own "language" that is very similar to Docker.

It only have 4 instruction possible:

`DEST`:    The p2p server name to use as destination.

`CTX`:     Change the remote directory (cd).

`COPY`:    Copy the comma separated files to the distant host.

`COMMAND`: Execute a shell command on the remote host.

```
DEST frontend-srv
CTX /home/user/website
COPY config.ini,build.sh,run.sh,app/
COMMAND sh build.sh
COMMAND sh run.sh
DEST backend-srv
CTX /usr/backend
COPY config.ini,backend.sh
COMMAND sh backend.sh

```
And boom !

## Develop on p2p

- Ruby is required
- Gem and bundle are required
1. Install gems 
```shell
bundle install
```
2. Configure p2p
```shell
sh config.sh
```
3. (Optional) Install rubyc to compile p2p from [ruby-packer](https://github.com/pmq20/ruby-packer/releases )

### Folders
`lib/` -> The p2p libraries, to use ssh or to store datas...
`cli/` -> The thor cli classes.
`scripts/` -> Useful script to build of configure p2p

### Pack
Pack p2p is simply moving all ressources to the folder `packed/` and prepare them to be installed.
Committing a pack to the main branch is uploading a new version of p2p !
To install the packed package locally for developpement test you can use
```shell
sudo sh scripts/install-packed.sh
```
This will install p2p with the latest local pack.

## P2P Webui
P2P webui is another part of the p2p project. It's an experimental web interface where you can debug and view your p2p deployements !

To install it run
```shell
wget https://raw.githubusercontent.com/camarm-dev/p2p/main/webui/install.sh | sudo sh
```

p2p-ui command will be installed... This command will be executed at each p2p deployement, and it will run a webserver to access a webui. Press `ctrl-c` to stop server.

You can run it manually: `p2p-ui start [deployment-id: not required]`. Go to http://localhost:16216 and view all your previous deployments...

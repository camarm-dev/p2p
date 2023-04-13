# Push to prod
Push 2 prod: the easiest and modern way to push any apps to production in one command.

## What does p2p ?
P2p is a command line tool written in ruby that push any apps to production with a single configuration file and in one command.
It uses ssh and don't required any agent on the distant machine.

1. Add the distant machine using p2p and give it a name.
2. Write a config file named `.p2p` at your project root.
3. Execute `p2p` at your project root.

And your app is now running on your distant host !

# Documentation

## Install

```shell
curl https://github.com/camarm-dev/p2p/tree/main/install.sh?raw=true sh
```
And follow the wizard...

## Add an host
```shell
p2p server add
```
Follow the wizard...

## Write a configuration file
```ini
P2P
server=server-name
copy=config.ini,app/,run.sh
execute=run.sh
CLI
verbose=false
```

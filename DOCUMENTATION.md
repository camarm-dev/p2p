<p align="center">

<img width="1000" src=".github/documentation.png" alt="P2P documentation">

# Push to prod - Documentation
Push 2 prod: the easiest and modern way to push any apps to production in one command.

</p>

## Table of content
- [Install](#installation)
- [Commands](#commands)
  - [Utilities](#p2p-commands)
  - [Servers](#p2p-servers)
  - [Settings](#p2p-settings--p2p--)
- [Settings](#settings)
- [Write a deployment file](#write-a-deployment-file)
- [Develop on p2p](#develop-on-p2p)

## Installation
Requirements:
- Ruby, gem and bundler
- ping
- openssh
- scp
- tar
- curl
```shell
curl https://raw.githubusercontent.com/camarm-dev/p2p/main/install.sh | sudo sh
```

## Commands

The Cli is divided in three big parts:

| [p2p](#p2p-commands)           | [p2p servers](#p2p-servers) | [p2p !](#p2p-settings--p2p--) |
|--------------------------------|-----------------------------|-------------------------------|
| Execute a .p2p file.           | Add / remove servers        | Edit settings                 |
| Create a .p2p file.            | Check servers informations  | List settings                 |
| Give infos about installation. | Test servers connectivity   |                               |
| Update p2p                     |                             |                               |

### P2P commands


<details>

<summary><b>info</b></summary>

aliases: `-v, --version, version`
```shell
$~ p2p info
 Installed path: /usr/lib/p2p/cli/p2p.rb
 Version: 0.0.0
 Changelog: P2P V0.1.6 now includes `p2p init`, a command to easily create a .p2p file and changelog !
```
>Gives version and installation path.

</details>


<details>

<summary><b>--exec, --push</b></summary>

#### Execute deployment

See also: [Write a deployment file](#write-a-deployment-file)

arguments: `--file`, choose the p2p file to execute (**optional**, **default**: .p2p)


aliases: `-e, -p`
 ```shell
 $~ p2p -e
Connecting to rpi ᯤ✔️
  - Moving to /home/robert/Projects 📂✔️
  - Executing `mkdir -p test` 💥✖️
    -> Please note that P2P have problems with `mkdir` command 📂✖️
  - Moving to test 📂✔️
  - Executing `ls` 💥✔️
   -> main.py
  - Copying examples/main.py 📎✔️
  - Executing `python3 mai.py` 💥✖️
   -> python3: can't open file 'mai.py': [Errno 2] No such file or directory

Connecting to pve ᯤ✔️
        - Moving to /root 📂✔️
        - Executing `whoami` 💥✔️
           -> root
```
>Execute the .p2p file.

</details>


<details>

<summary><b>init</b></summary>

arguments: `--server`, choose server to use (**required**)

See also: [Write a deployment file](#write-a-deployment-file)

 ```shell
$~ p2p init --server rpi
  Connecting to rpi... Type "close" to exit and "abort" to abort.
  robert@192.168.1.167:/home/robert $ close
  .p2p file successfully generated ✅
```
>Create a .p2p file by saving every command you type.

</details>


<details>

<summary><b>update</b></summary>

arguments: `--version`, choose the p2p version to install (can be both of downgrade or upgrade) (**optional**, **default**: latest)

 ```shell
 $~ p2p update
 [...]
 P2P successfully updated ! Execute p2p info to see installed version
```
>Install the latest p2p version.

</details>


### P2P servers


<details>

<summary><b>add</b></summary>

```shell
 $~ p2p servers add
 Complete the following wizard to add a p2p server:
 Enter server hostname (e.g 45.67.89.67, server.domain.com) >>> 
```
>Add a p2p server, by following a wizard

</details>


<details>

<summary><b>list</b></summary>

```shell
 $~ p2p servers list
Registered servers:
pve             -       root@192.168.1.x
rpi             -       user@192.168.1.x
planteqr        -       root@192.168.1.x
```
>List p2p servers

</details>


<details>

<summary><b>remove [server]</b></summary>

```shell
 $~ p2p servers remove pve
Server successfully deleted ✅
```
>Remove p2p server named <server>

</details>


<details>

<summary><b>spec [server]</b></summary>

```shell
 $~ p2p servers spec pve
Specs of 'pve':
hostname:          192.168.1.x
user:              root
port:              22
require_password:  false
name:              pve
```
>Show specifications of p2p server named <server>

</details>


<details>

<summary><b>test [server]</b></summary>

```shell
 $~ p2p servers test pve
Testing 'pve':
Server 'pve' has been tested successfully. ✅
```
>Test the connectivity of the p2p server named <server>

</details>


### P2P settings (p2p !)


<details>

<summary><b>set [setting] [value]</b></summary>

```shell
 $~ p2p ! set emojis fancy
  Successfully set 'emojis' to 'fancy' 📂✔️
```
>Set `key` setting to value

</details>


<details>

<summary><b>list</b></summary>

```shell
 $~ p2p ! list
Settings 📃️
data:    []
emojis:  fancy
```
>List p2p settings

</details>

## Settings
Settings are updatable with `p2p ! set [setting] [value]`
The list of avaible settings and their possible values is above:
- `emojis` = `fancy` | `classic` 
  - > Fancy will show emojis that require a special font, classic will ensure you that output will never print bugged chars.
- `color` = `yes` | `no` 
  - > Yes will enable ANSI color outputs, no will disable colored outputs.

## Write a deployment file
P2P has his own "language" that is very similar to Docker.

It only has 4 instruction possible:

`DEST`:    The p2p server name to use as destination.

`CTX`:     Change the remote directory (cd).

`COPY`:    Copy the comma separated files to the distant host.

`COMMAND`: Execute a shell command on the remote host.

```
DEST frontend-srv

# P2P supports blank lines and comments !
# The next block concern frontend-srv

CTX /home/user/website
COPY config.ini,build.sh,run.sh,app/
COMMAND sh build.sh
COMMAND sh run.sh

# Another block that concern backend-srv server
DEST backend-srv
CTX /usr/backend
COPY config.ini,backend.sh
COMMAND sh backend.sh
```
The example file above will output something like [this](#execute-deployment).

This video explain line by line what the interpreter does:


https://user-images.githubusercontent.com/77529508/236801291-eca23bac-28e0-401b-ad90-cc77f190a0f3.mp4


## Develop on p2p

- Ruby is required
- Gem and bundle are required
1. Install gems
```shell
bundle install
```
2. Configure p2p
```shell
sh scripts/config.sh
```

### Folders
`lib/` -> The p2p libraries, to use ssh or to store datas...
  - `ansi.rb` -> Ansi code constants used for terminal outputs
  - `servers.rb` -> Servers management class (remove, test, get...)
  - `storage/utils.rb` -> Store & read p2p data (manage json files in `~/.p2p`)
  - `net/utils.rb` -> Wrapper of ruby net-ssh & net-scp, for p2p
  - `eval/eval.rb` -> Execute p2p code

`cli/` -> The thor cli classes.
  - `p2p.rb` -> Main file and Class for [p2p utilities](#p2p-commands)
  - `servers.rb` -> Class for [p2p servers cli](#p2p-servers)

`scripts/` -> Useful script to build of configure p2p
  - `config.sh` -> Fetch and write default `config.default.json` file as `~/.p2p/config.json`
  - `pack.sh` -> [Pack](#pack)
  - `install-packed.sh` -> Install the latest local "pack" (in folder packed/) in `/usr/lib/p2p`
  - `utils/full-path.rb` -> Replace ruby import relative path to absolute path (eg replace in folder test: `ruby full-path.rb test/`)

### Pack
Pack p2p is simply moving all ressources to the folder `packed/` and prepare them to be installed.
The `packed/` folder of the main branch is downloaded when p2p is installed !
Committing a pack to the main branch is uploading a new version of p2p !
To install the packed package locally for developpement test you can use
```shell
sudo sh scripts/install-packed.sh
```
This will install p2p with the latest local pack.



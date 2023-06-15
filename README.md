<div align="center">

<img width="1000" src=".github/header.png" alt="Push 2 Prod">

# Push to prod
Push 2 prod: the easiest and modern way to push any apps to production in one command.

</div>

## Table of content
- [What does p2p ?](#what-does-p2p-)
- [Install](#installation)
- [Documentation](https://github.com/camarm-dev/p2p/blob/main/DOCUMENTATION.md)
- [Acknowledgement](#acknowledgement)

## What does p2p ?
P2p is a command line tool written in ruby that push any apps to production with a single configuration file and in one command.
It uses ssh and don't required any agent on the distant machine.

1. Add the distant machine using p2p and give it a name.
2. Write a config file named `.p2p` at your project root.
3. Execute `p2p -e` at your project root.

And your app is now running on your distant host !


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

## Acknowledgement
- Rocket icon by [Etta](https://www.svgrepo.com/author/Etta/).
- Logo by @camarm (armand@camponovo.xyz) under [CC BY-NC-ND 3.0 FR](https://creativecommons.org/licenses/by-nc-nd/3.0/fr/).
- Code under [MIT Licence](https://github.com/camarm-dev/p2p/blob/main/LICENCE), attribution to @camarm (armand@camponovo.xyz).

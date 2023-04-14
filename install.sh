#!/bin/bash
if [ "$(whoami)" = "root" ]; then
  echo "Installing p2p in /usr/bin"
  curl https://github.com/releases/lastest/ -o /usr/bin/p2p
  chmod +x /usr/bin/p2p
  echo "Creating data folder ~/.p2p"
  mkdri -p ~/.p2p
  echo "Writting default configuration"
  curl https://raw.githubusercontent.com/camarm-dev/p2p/main/config.default.json > ~/.p2p/config.json
  echo "Running p2p info"
  p2p info
  echo "The p2p executable is installed !"
else
  echo "Run this as root"
  exit 255
fi

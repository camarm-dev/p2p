#!/bin/bash
if [ "$(whoami)" = "root" ]; then
  echo "Installing p2p in /usr/bin"
  cp packed/p2p /usr/bin/p2p
  chmod +x /usr/bin/p2p
  echo "Installing p2p libraries in /usr/lib"
  cp -r packed/p2p-libs /usr/lib/p2p
  echo "Creating data folder ~/.p2p"
  mkdir -p ~/.p2p
  echo "Writing default configuration"
  curl https://raw.githubusercontent.com/camarm-dev/p2p/main/config.default.json -s -o ~/.p2p/config.json
  echo "Running p2p info"
  p2p info
  echo "The p2p executable is installed !"
else
  echo "Run this as root"
  exit 255
fi

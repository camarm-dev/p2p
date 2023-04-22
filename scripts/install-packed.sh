#!/bin/bash
if [ "$(whoami)" = "root" ]; then
  echo "Installing p2p in /usr/bin"
  cp packed/p2p /usr/bin/p2p
  chmod +x /usr/bin/p2p
  echo "Installing p2p libraries in /usr/lib"
  mkdir -p /usr/lib/p2p
  cp -r packed/p2p-libs/* /usr/lib/p2p
  echo "Creating data folder ~/.p2p"
  su $SUDO_USER -c 'mkdir -p ~/.p2p'
  echo "Writing default configuration"
  su $SUDO_USER -c 'curl https://raw.githubusercontent.com/camarm-dev/p2p/main/config.default.json -s -o ~/.p2p/config.json'
  echo "Running p2p info"
  su $SUDO_USER -c 'p2p info'
  echo "The p2p executable is installed !"
else
  echo "Run this as root"
  exit 255
fi

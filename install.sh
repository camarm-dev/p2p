#!/bin/bash
if [ "$(whoami)" = "root" ]; then
  echo "Installing p2p in /usr/bin"mks
  curl https://github.com/releases/lastest/ -o /usr/bin/p2p
  chmod +x /usr/bin/p2p
  echo "Running p2p info"
  p2p info
  echo "The p2p executable is installed !"
else
  echo "Run this as root"
  exit -1
fi

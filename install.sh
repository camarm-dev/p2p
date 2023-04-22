#!/bin/bash
if [ "$(whoami)" = "root" ]; then
  ruby --version > /dev/null

  if [ $? != 0 ]; then
      echo "Please install ruby"
      exit
  fi

  tar --version > /dev/null

  if [ $? != 0 ]; then
      echo "Please install tar"
      exit
  fi

  ping -V > /dev/null

  if [ $? != 0 ]; then
      echo "Please install ping"
      exit
  fi

  ssh -V > /dev/null

  if [ $? != 0 ]; then
      echo "Please install openssh"
      exit
  fi

  echo "Installing p2p in /usr/bin"
  curl https://raw.githubusercontent.com/camarm-dev/p2p/main/packed/p2p -s -o /usr/bin/p2p
  chmod +x /usr/bin/p2p
  echo "Installing p2p libraries in /usr/lib"
  curl https://raw.githubusercontent.com/camarm-dev/p2p/main/packed/p2p-libs.tar.gz -s -o libs.tar.gz
  tar -xzvf libs.tar.gz -C /usr/lib/p2p
  rm libs/tar.gz
  echo "Creating data folder ~/.p2p"
  su $USER -c 'mkdir -p ~/.p2p'
  echo "Writing default configuration"
  su $USER -c 'curl https://raw.githubusercontent.com/camarm-dev/p2p/main/config.default.json -s -o ~/.p2p/config.json'
  echo "Running p2p info"
  su $USER -c 'p2p info'
  echo "The p2p executable is installed !"
else
  echo "Run this as root"
  exit 255
fi

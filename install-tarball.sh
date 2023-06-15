#!/bin/bash
if [ "$(whoami)" = "root" ]; then
  ruby --version > /dev/null

  if [ $? != 0 ]; then
      echo "Please install ruby"
      exit
  fi

  gem --version > /dev/null

  if [ $? != 0 ]; then
      echo "Please install gem"
      exit
  fi

  bundle --version > /dev/null

  if [ $? != 0 ]; then
      echo "Please install bundler for gem"
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

  echo "Installing dependencies"
  curl https://raw.githubusercontent.com/camarm-dev/p2p/main/Gemfile -s -o Gemfile
  bundle install
  rm Gemfile
  echo "Installing p2p in /usr/bin"
  curl https://raw.githubusercontent.com/camarm-dev/p2p/main/packed/p2p -s -o /usr/bin/p2p
  chmod +x /usr/bin/p2p
  echo "Installing p2p libraries in /usr/lib"
  mkdir -p /usr/lib/p2p
  tar -xzvf libs.tar.gz -C /usr/lib/p2p
  rm libs.tar.gz
  echo "Creating data folder ~/.p2p"
  su $SUDO_USER -c 'mkdir -p ~/.p2p'
  echo "Running p2p info"
  su $SUDO_USER -c 'p2p info'
  echo "The p2p executable is installed !"
else
  echo "Run this as root"
  exit 255
fi

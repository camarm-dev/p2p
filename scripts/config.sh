#!/bin/bash
echo "Creating data folder ~/.p2p"
mkdir -p ~/.p2p
echo "Writting default configuration"
curl https://raw.githubusercontent.com/camarm-dev/p2p/main/config.default.json -s -o ~/.p2p/config.json
echo "The p2p environnement is installed !"

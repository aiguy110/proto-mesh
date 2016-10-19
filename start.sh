#!/bin/bash

# Verify that the config file exists
if [ ! -f config ]; then
    echo 'config file not present! Aborting.'
    exit
fi

# Load config file
source config

# We're starting! :D
echo "Starting proto-mesh..."

# Initialize the network interface
bash $IFACE_SETUP_SCRIPT

# Do other things
cd utils

bash require-dependencies.sh
bash batman-start.sh

# If KadNode name resolution is enabled, wait for neighbors
# and then start KadNode
if [ $ENABLE_KADNODE == '1' ]; then 
   bash wait-for-neighbor.sh
   bash kadnode-start.sh $HOSTNAME
fi

cd ../

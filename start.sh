#!/bin/bash
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
bash wait-for-neighbor.sh
bash kadnode-start.sh $HOSTNAME

cd ../

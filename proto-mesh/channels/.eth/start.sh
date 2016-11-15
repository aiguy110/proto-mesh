#!/bin/bash

# Make sure config exists
if [ ! -f ./.eth/config ]; then
    echo 'WiFi config file not present! Please add one at "proto-mesh/channels/.wifi/config"'
    echo 'Aborting...'
    exit
fi

# Load config
source ./.eth/config

# Get our classic 802.11 ad-hoc network up
ip link set down dev $IFACE
ip link set up dev $IFACE

# Add it as a batman interface
batctl if add $IFACE

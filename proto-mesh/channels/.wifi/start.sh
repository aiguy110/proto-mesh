#!/bin/bash

# Make sure config exists
if [ ! -f ./.wifi/config ]; then
    echo 'WiFi config file not present! Please add one at "proto-mesh/channels/.wifi/config"'
    echo 'Aborting...'
    exit
fi

# Load config
source ./.wifi/config
CHANNEL=$1

# Get our classic 802.11 ad-hoc network up
ip link set down dev $IFACE
iwconfig $IFACE mode ad-hoc
iwconfig $IFACE channel $CHANNEL
iwconfig $IFACE essid $ESSID
ip link set up dev $IFACE

# Add it as a batman interface
batctl if add $IFACE

#!/bin/bash
# Make sure config exists
if [ ! -f ./.wifi/config ]; then
    echo 'WiFi config file not present! Please add one at "proto-mesh/channels/.wifi/config"'
    echo 'Aborting...'
    exit
fi

# Load config
source ./.wifi/config

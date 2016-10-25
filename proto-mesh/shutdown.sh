#!/bin/bash

# Verify that the config file exists
if [ ! -f config ]; then
    echo 'config file not present! Aborting.'
    exit
fi

# Load settings
source config

# Kill KadNode if its running
if [ $ENABLE_KADNODE == '1' ]; then
   kill $(ps -ef | grep kad | grep daemon | awk '{print $2}')
fi

# Unload the batman-adv kernal module
modprobe -r batman-adv

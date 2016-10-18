#!/bin/bash
# Load settings
source config

# Kill KadNode if its running
if [ $ENABLE_KADNODE == '1' ]; then
   kill $(ps -ef | grep kad | grep daemon | awk '{print $2}')
fi

# Unload the batman-adv kernal module
modprobe -r batman-adv

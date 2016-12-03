#!/bin/bash

# Verify that the config file exists
if [ ! -f config ]; then
    echo 'config file not present! Aborting.'
    exit
fi

# Load settings
source /etc/proto-mesh/config

#Initialize Close Bridge if Server
if [ $NET_GATEWAY == 'server' ]; then
    ip link set br0 down
    brctl delbr br0
fi

# Kill KadNode if its running
if [ $ENABLE_KADNODE == '1' ]; then
   kill $(ps -ef | grep kad | grep daemon | awk '{print $2}')
fi

#Shutdown Network Interface
if [ -d /etc/proto-mesh/channels/$DEFAULT_CHANNEL ]
then
  cd /etc/proto-mesh/channels
	bash $DEFAULT_CHANNEL/stop.sh
else
	echo "Interface/Channel Not Defined!"
fi

# Unload the batman-adv kernal module
modprobe -r batman-adv

#!/bin/bash

# Verify that the config file exists
if [ ! -f config ]; then
    echo 'config file not present! Aborting.'
    exit
fi

# Load config file
source ./config

# We're starting! :D
echo "Starting proto-mesh..."

if [ -d ./channels/$DEFAULT_CHANNEL ]
then
  # Enable the batman-adv kernal module
  modprobe batman-adv
  if [ $? != 0 ]; then echo 'batman-adv kernal module not present!';exit -1; fi

	# Initialize the network interface
	cd channels
	bash $DEFUALT_CHANNEL/start.sh
	cd ../

  # Start BATMAN-adv, and wait before attempting to assign IP address
  while true
  do
     sleep 1
     if [ $? == 0 ]; then break; fi
  done

  if [ $? == 0 ]
     then echo 'Successfully started BATMAN-adv!'
     else
        echo 'Unable to start BATMAN-adv.'
        exit -1
  fi

  # Find out what interface was added
  IFACE=$(batctl if)
  if [ -z $IFACE ]; then
    echo "Failed to open channel \"$DEFUALT_CHANNEL\""
    echo "Aborting..."
    exit -1
  fi

  # Generate and assign an IPv4 address using this interface's MAC address
  cd utils
  python3 giveIPv4.py $DEFAULT_IFACE bat0
  cd ../

	# Do other things

	#Initialize Gateway based on config
	if [ $NET_GATEWAY == 'server' ]; then
   		echo "Setting up Batman Network Gateway"
   		sudo batctl bl 1
   		sudo brctl addbr br0
   		sudo brctl addif br0 bat0 eth0
	elif [ $NET_GATEWAY == 'client' ]; then
   		echo "Setting up Batman Network Client"
   		sudo batctl bl 1
	else
	    sudo batctl bl 1
	fi

	# If KadNode name resolution is enabled, wait for neighbors
	# and then start KadNode
	if [ $ENABLE_KADNODE == '1' ]; then
   		bash wait-for-neighbor.sh
   		bash kadnode-start.sh $HOSTNAME
	fi

	cd ../

else
	echo "Interface/Channel Not Defined!"
fi

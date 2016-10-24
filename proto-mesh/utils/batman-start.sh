#!/bin/bash
# Load config file
source ../config

# Enable the batman-adv kernal module
modprobe batman-adv
if [ $? != 0 ]; then echo 'batman-adv kernal module not present!';exit 1; fi

# Start BATMAN-adv on top of that, but first make sure batman is ready
while true
do
   sleep 1
   batctl if add $NETWORK_IFACE
   if [ $? == 0 ]; then break; fi
done 

if [ $? == 0 ]
   then echo 'Successfully started BATMAN-adv!'
   else 
      echo 'Unable to start BATMAN-adv.'
      exit 1
fi

# Generate and assign the bat0 an IPv6 address
python3 giveIPv4.py $NETWORK_IFACE bat0

#!/bin/bash
echo 'Starting script...'

modprobe batman-adv
# May have to insert a delay here to give bat0 time to become available

# Get our classic 802.11 ad-hoc network up
ip link set wlan0 down
iwconfig wlan0 mode ad-hoc
iwconfig wlan0 channel 1
iwconfig wlan0 essid 'mesh2'
ip link set wlan0 up

# Start BATMAN-adv on top of that
batctl gw_mode client
batctl if add wlan0

# See if we can get a free IP configuration from another DHCP server on the network
HAVE_IP="0"
dhclient -1 bat0 
if [ $? == 0 ]
   then 
      echo 'Got an IP!'
      HAVE_IP="1"
fi
export HAVE_IP
echo 'End of script'


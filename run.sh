#!/bin/bash
echo 'Starting proto-mesh Setup...'

modprobe batman-adv
# May have to insert a delay here to give bat0 time to become available

# Before we actually connect to the batman-adv mesh, lets see if we have internet of our own
HAVE_INET=0
ping -c 1 8.8.8.8
if [ $? == 0 ]; then HAVE_INET=1;fi

# Get our classic 802.11 ad-hoc network up
ip link set wlan0 down
iwconfig wlan0 mode ad-hoc
iwconfig wlan0 channel 1
iwconfig wlan0 essid 'mesh2'
ip link set wlan0 up

# Start BATMAN-adv on top of that
batctl gw_mode client
batctl if add wlan0
if [ $? == 0 ]
   then echo 'Successfully started BATMAN-adv!'
   else 
      echo 'Unable to start BATMAN-adv.'
      exit 1
fi

# See if we can get an IP configuration from a DHCP server already
# on the network.
FIRST_ARRIVER=1
dhclient -1 bat0 
if [ $? == 0 ]
   then 
      echo 'Got an IP from the network!'
      FIRST_ARRIVER=0
   else
      echo 'Could not get IP from the network.\nUsing default IP: $PERFERED_IP'
      ip addr add $PERFERED_IP dev bat0
fi 

# If we have Internet access, we are starting a DHCP server no matter what 
# so batman can help us be a gateway node. However, even if we do not have
# Internet access, if we are the first node in the network (i.e. we were
# not given our IP by any external  DHCP server), then we need to host a 
# DHCP server anyway to make sure no new nodes take our address on accident.
if [ $HAVE_INET == 1 ]
   then 
      dnsmasq -i bat0 --dhcp-option=3,$DEFAULT_ADDR
   else
      if [ $FIRST_ARRIVER == 1 ]:
         dnsmasq -i bat0

echo 'End of script'


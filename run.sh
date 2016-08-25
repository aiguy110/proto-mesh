#!/bin/bash
echo 'Starting proto-mesh Setup...'

# Load config file
source config

# Enable the batman-adv kernal module
modprobe batman-adv
if [ $? != 0 ]; then echo 'batman-adv kernal module not present!';exit 1; fi

# Verify that some packages are installed
require-package (){
   which $1 > /dev/null
   if [ $? != 0 ]
      then
         echo "Package $1: Installing..."
         apt-get install --assume-yes $1 > /dev/null
         echo "Package $1: Complete."
      else
         echo "Package $1: Already installed."
   fi
}
require-package batctl
require-package dnsmasq
require-package ip


# Before we actually connect to the batman-adv mesh, lets see if we have internet of our own
HAVE_INET=0
ping -c 1 8.8.8.8 > /dev/null
if [ $? == 0 ] 
   then 
      HAVE_INET=1
      echo 'Founded pre-existing internet connection!'
   else
      echo 'Unable to find pre-existing internet connection!'
fi

# Get our classic 802.11 ad-hoc network up
ip link set $WIRELESS_IFACE down
iwconfig $WIRELESS_IFACE mode ad-hoc
iwconfig $WIRELESS_IFACE channel 1
iwconfig $WIRELESS_IFACE essid 'mesh2'
ip link set $WIRELSS_IFACE up

# Start BATMAN-adv on top of that, but first make sure batman is ready
while true
do
   sleep 1
   batctl if add $WIRELESS_IFACE
   if [ $? == 0 ]; then break; fi
done 

batctl gw_mode client
if [ $? == 0 ]
   then echo 'Successfully started BATMAN-adv!'
   else 
      echo 'Unable to start BATMAN-adv.'
      exit 1
fi

# See if we can get an IP configuration from a DHCP server already
# on the network.
# Set dhclient timeout time to something more reasonable
sed -i s/'#timeout 60'/'timeout 5'/g /etc/dhcp/dhclient.conf 
FIRST_ARRIVER=1
dhclient -1 bat0 
if [ $? == 0 ]
   then 
      echo 'Got an IP from the network!'
      FIRST_ARRIVER=0
   else
      echo "Could not get IP from the network."
      echo "Using default IP: $DEFAULT_EXIP"
      ip addr add $DEFAULT_EXIP dev bat0
fi 

# If we have Internet access, we are starting a DHCP server no matter what 
# so batman can help us be a gateway node. However, even if we do not have
# Internet access, if we are the first node in the network (i.e. we were
# not given our IP by any external  DHCP server), then we need to host a 
# DHCP server anyway to make sure no new nodes take our address on accident.
service dnsmasq stop
if [ $HAVE_INET == 1 ]
   then 
      dnsmasq -i bat0 --dhcp-option=3,$DEFAULT_ADDR
   else
      if [ $FIRST_ARRIVER == 1 ]; then dnsmasq -i bat0; fi

fi
echo 'End of script'


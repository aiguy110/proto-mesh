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

require-git-package(){
   if [ ! -d "./git-packages/$1" ]
      then
         echo "Git-Package $1: Installing..."
         mkdir -p "./git-packages/$1"
         git clone "https://github.com/$1" "./git-packages/$1"
         cd "./git-packages/$1"
         make
         sudo make install
         cd ../../../
         echo "Git-Package $1: Complete.
      else
         echo "Git-Package $1: Already installed
   fi
}    
   
require-package batctl
require-package dnsmasq
require-package ip
require-package libsodium-dev
require-git-package mwarning/KadNode



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
ip link set dev $WIRELESS_IFACE down
iwconfig $WIRELESS_IFACE mode ad-hoc
iwconfig $WIRELESS_IFACE channel 1
iwconfig $WIRELESS_IFACE essid 'mesh2'
ip link set dev $WIRELESS_IFACE up

# Start BATMAN-adv on top of that, but first make sure batman is ready
while true
do
   sleep 1
   batctl if add $WIRELESS_IFACE
   if [ $? == 0 ]; then break; fi
done 

if [ $? == 0 ]
   then echo 'Successfully started BATMAN-adv!'
   else 
      echo 'Unable to start BATMAN-adv.'
      exit 1
fi

# Generate and assign the bat0 an IPv6 address
python3 giveIPv4.py wlan0 bat0

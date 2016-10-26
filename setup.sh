#!/bin/bash

FILE="/etc/proto-mesh/utils/protomesh.service"
# Make sure proto-mesh is not already "installed"
if [ -f "$FILE" ] && [ "$1" != '-f' ]
then
   echo "Proto-mesh already configured to start at boot."
   echo "(Use -f if neccessary)"
   exit
fi

echo "Intiailzing..."

# Enable the batman-adv kernal module
modprobe batman-adv
if [ $? != 0 ]; then echo 'batman-adv kernal module not present!';exit 1; fi

echo "Copying Files..."
sudo cp -rf proto-mesh /etc/proto-mesh

# Generate Sample Config if Necessary
if [ ! -f /etc/proto-mesh/config ]
then
    echo "Generating Config File (1/2)..."
    sudo cp /etc/proto-mesh/config.sample /etc/proto-mesh/config
fi

# Generate Sample Config if Necessary
if [ ! -f /etc/proto-mesh/wifi/wireless-config ]
then
    echo "Generating Config File (2/2)..."
    sudo cp /etc/proto-mesh/wifi/wireless-config.sample /etc/proto-mesh/wifi/wireless-config
fi

echo "Installing Pre-Reqs..."
# Load config file
source /etc/proto-mesh/config

# Verify that some packages are installed
require-package (){
   if [ ! -z "$2" ] 
      then
         ldconfig -p | grep $2 > /dev/null
      else
         which $1 > /dev/null
   fi
   if [ $? != 0 ]
      then
         echo "Package $1: Installing..."
         apt-get install --assume-yes $1 > /dev/null
         echo "Package $1: Complete."
      else
         echo "Package $1: Already installed."
   fi
}
# Verify that some packages are installed
require-git-package(){
   if [ ! -d "/etc/proto-mesh/git-packages/$1" ]
      then
         echo "Git-Package $1: Installing..."
         mkdir -p "/etc/proto-mesh/git-packages/$1"
         git clone "https://github.com/$1" "/etc/proto-mesh/git-packages/$1" > /dev/null
         cd "/etc/proto-mesh/git-packages/$1"
         make > /dev/null
         sudo make install > /dev/null
         cd ../
         echo "Git-Package $1: Complete."
      else
         echo "Git-Package $1: Already installed"
   fi
}    
 
#Install Required Packages  
require-package batctl
require-package python3
require-package ip
require-package libsodium-dev libsodium
if [ $ENABLE_KADNODE == '1' ]; then
  require-git-package mwarning/KadNode
fi

#Generate Service File
echo "Generating Service File..."
sudo cp /etc/proto-mesh/utils/protomesh.service /etc/systemd/system/protomesh.service

#Enable and Start Service
echo "Starting protomesh service..."
sudo systemctl enable protomesh.service
sudo systemctl daemon-reload
sudo systemctl start protomesh.service
echo "Setup Complete!"

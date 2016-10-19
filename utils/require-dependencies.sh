#!/bin/bash
# Load config file
source ../config

# Enable the batman-adv kernal module
modprobe batman-adv
if [ $? != 0 ]; then echo 'batman-adv kernal module not present!';exit 1; fi

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

require-git-package(){
   if [ ! -d "../git-packages/$1" ]
      then
         echo "Git-Package $1: Installing..."
         mkdir -p "../git-packages/$1"
         git clone "https://github.com/$1" "../git-packages/$1" > /dev/null
         cd "../git-packages/$1"
         make > /dev/null
         sudo make install > /dev/null
         cd ../../../
         echo "Git-Package $1: Complete."
      else
         echo "Git-Package $1: Already installed"
   fi
}    
   
require-package batctl
require-package python3
require-package ip
require-package libsodium-dev libsodium
if [ $ENABLE_KADNODE == '1' ]; then
  require-git-package mwarning/KadNode
fi

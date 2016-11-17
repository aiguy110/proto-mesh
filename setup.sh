#!/bin/bash

INSTALL_PATH="/etc/proto-mesh"

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
if [ $? != 0 ]; then echo 'batman-adv kernal module not present!';exit -1; fi

echo "Copying Files..."
sudo cp -rf proto-mesh $INSTALL_PATH

# Add a logical link to the command line interface in /bin
ln -s -T $INSTALL_PATH/meshcli.sh /bin/meshcli

# Generate Config if Necessary
if [ ! -f $INSTALL_PATH/config ]; then
  echo "Generating Config File..."
  sudo cp $INSTALL_PATH/config.sample $INSTALL_PATH/config

  # Setup a system wide definition for MESH_DIR
  if [ ! -f /etc/environment ]; then
    echo "MESH_DIR=$INSTALL_PATH" > /etc/environment
  else
    grep MESH_DIR=$MESH_DIR /etc/environment
    if [ $? == 0 ]; then
      sudo sed -i -e "s:MESH_DIR=$MESH_DIR:MESH_DIR=$INSTALL_PATH:g" /etc/environment
    else
      sudo echo "MESH_DIR=$INSTALL_PATH" >> /etc/environment
    fi
  fi
fi



# Generate WiFi Config if Necessary
if [ ! -f $INSTALL_PATH/channels/.wifi/config ]
then
    echo "Generating Wifi Config File..."
    sudo cp $INSTALL_PATH/channels/.wifi/config.sample $INSTALL_PATH/channels/.wifi/config
fi

echo "Installing Pre-Reqs..."

# Load config file
source $INSTALL_PATH/config

# Verify that some packages are installed
requirepackage(){
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
requiregitpackage(){
   if [ ! -d "$INSTALL_PATH/git-packages/$1" ]
      then
         echo "Git-Package $1: Installing..."
         mkdir -p "$INSTALL_PATH/git-packages/$1"
         git clone "https://github.com/$1" "$INSTALL_PATH/git-packages/$1" > /dev/null
         cd "$INSTALL_PATH/git-packages/$1"
         make > /dev/null
         sudo make install > /dev/null
         cd ../
         echo "Git-Package $1: Complete."
      else
         echo "Git-Package $1: Already installed"
   fi
}

#Install Required Packages
requirepackage batctl
requirepackage python3
requirepackage ip
requirepackage libsodium-dev libsodium
requirepackage bridge-utils

if [ $ENABLE_KADNODE == '1' ]; then
  requiregitpackage mwarning/KadNode
fi

#Generate Service File
echo "Generating Service File..."
sudo cp $INSTALL_PATH/utils/protomesh.service /etc/systemd/system/protomesh.service

#Make Start/Stop Scripts Executable
echo "Setting Permissions..."
sudo chmod +x $INSTALL_PATH/start.sh
sudo chmod +x $INSTALL_PATH/shutdown.sh

#Enable and Start Service
echo "Starting protomesh service..."
sudo systemctl enable protomesh.service
sudo systemctl daemon-reload
sudo systemctl start protomesh.service
echo "Setup Complete!"

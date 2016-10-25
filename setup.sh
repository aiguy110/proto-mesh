#!/bin/bash

FILE="/etc/proto-mesh/utils/protomesh.service"
# Make sure proto-mesh is not already "installed"
if [ -f "$FILE" ] && [ "$1" != '-f' ]
then
   echo "Proto-mesh already configured to start at boot."
   echo "(Use -f if neccessary)"
   exit
fi

#Find out where this directory is and modify the boot-code snippet to reflect this
echo "Copying Files.."
sudo cp -rf proto-mesh /etc/proto-mesh
echo "Intiailzing.."
sudo cp /etc/proto-mesh/utils/protomesh.service /etc/systemd/system/protomesh.service
echo "Generating Config File..."
sudo cp /etc/proto-mesh/config.sample /etc/proto-mesh/config
sudo systemctl enable protomesh.service
sudo systemctl daemon-reload
sudo systemctl start protomesh.service
echo "Setup Complete!"

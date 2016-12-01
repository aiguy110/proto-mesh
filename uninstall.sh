#!/bin/bash

#Prompt to Confirm
read -p "Are you sure you wish to remove proto-mesh (Y/n)? " CONT
CONT=${CONT,,} # tolower
if [ "$CONT" = "n" ]; then
  #Report nothing has happened
  echo "Operation Canceled"
else
  echo "Disabling Proto-Mesh Service..."
  #Stop service if running
  sudo systemctl stop protomesh.service
  sudo systemctl disable protomesh.service
  #Remove Service File
  sudo rm -rf /etc/systemd/system/protomesh.service
  #Reload Systemctl
  echo "Reloading Systemctl..."
  sudo systemctl daemon-reload
  #Uninstall /etc/proto-mesh directory
  echo "Removing Uncescessary Files..."
  sudo rm -rf /etc/proto-mesh
  #Report done
  echo "Done! Proto-Mesh has been removed."
fi

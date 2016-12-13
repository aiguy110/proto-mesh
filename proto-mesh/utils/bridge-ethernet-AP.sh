#!/bin/bash

#run to allow batman to be visible by wireless access point
#allows access to interrior nodes within batman-adv mesh from WAP

#run this on wireless nodes connected to wireless router by ethernet

sudo ip link add name mesh-bridge type bridge
sudo ip link set dev eth0 master mesh-bridge
sudo ip link set dev bat0 master mesh-bridge
sudo ip link set up dev eth0
sudo ip link set up dev bat0
sudo ip link set up dev mesh-bridge

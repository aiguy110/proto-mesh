#!/bin/bash

# Load config
source /etc/proto-mesh/config

# Get our classic 802.11 ad-hoc network up
ip link set down dev wlan0
iwconfig wlan0 mode ad-hoc
iwconfig wlan0 channel 1
iwconfig wlan0 essid $ESSID
ip link set up dev wlan0

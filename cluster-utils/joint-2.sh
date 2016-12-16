#!/bin/bash



sudo ./command_joints.sh "sleep 30 && sudo batctl if add eth0 && sudo iwconfig wlan0 channel 06 && sudo batctl if add wlan0"

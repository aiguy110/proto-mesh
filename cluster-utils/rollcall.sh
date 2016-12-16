#!/bin/bash

sudo ./command_all.sh "echo \$(hostname && /sbin/ifconfig bat0 | grep 'inet addr' | cut -d ':' -f 2 | cut -d ' ' -f 1 && cat /sys/class/net/wlan0/address && sudo iwlist wlan0 channel | grep Current && echo)" 2> /dev/null

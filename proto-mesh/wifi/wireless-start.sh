#!/bin/bash

# Load config
source wifi/wireless-config

# Get our classic 802.11 ad-hoc network up
ip link set down dev $WIRELESS_IFACE
iwconfig $WIRELESS_IFACE mode ad-hoc
iwconfig $WIRELESS_IFACE channel $CHANNEL
iwconfig $WIRELESS_IFACE essid $ESSID
ip link set up dev $WIRELESS_IFACE

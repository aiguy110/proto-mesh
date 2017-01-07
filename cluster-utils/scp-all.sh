#!/bin/bash

TARGET=$1
DEST=${2:-"$(pwd)"}
PASS="raspberry"

sudo ./command_all.sh "sshpass -p $PASS scp -r -o StrictHostKeyChecking=no $TARGET pi@$(hostname).local:${DEST}.\$(hostname)"

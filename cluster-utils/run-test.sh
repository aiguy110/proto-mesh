#!/bin/bash
INTERVAL=${1:-1000}
BYTES=${2:-100}
COUNT=${3:-100}

echo "Interval: $INTERVAL"
echo "Bytes: $BYTES"
echo "Count: $COUNT"

DIRECTORY="~/testing/${BYTES}_bytes/$INTERVAL"

echo "Directory: $DIRECTORY"

sudo bash ./command_all.sh "sudo mkdir -p $DIRECTORY && sudo chmod -R 777 $DIRECTORY && sudo fping -b $BYTES -c $COUNT -p $INTERVAL -e -f bat-ips 1> $DIRECTORY/\$(hostname)_pings2.txt 2> $DIRECTORY/\$(hostname)_results2.txt"

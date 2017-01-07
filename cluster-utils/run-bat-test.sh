#!/bin/bash
INTERVAL=${4:-1000}
BYTES=${3:-128}
COUNT=${2:-100}
BATRATE=${1:-1000}

echo "Interval: $INTERVAL"
echo "Bytes: $BYTES"
echo "Count: $COUNT"
echo "Bat Rate: $BATRATE"

DIRECTORY="/home/pi/bat-tests/${BATRATE}"

echo "Directory: $DIRECTORY"

sudo bash ./command_all.sh "sudo batctl it $BATRATE && sleep 10 && sudo mkdir -p $DIRECTORY && sudo chmod -R 777 $DIRECTORY && sudo fping -b $BYTES -c $COUNT -p $INTERVAL -e -f /home/pi/bat-ips 1> $DIRECTORY/\$(hostname)_pings.txt 2> $DIRECTORY/\$(hostname)_results.txt"

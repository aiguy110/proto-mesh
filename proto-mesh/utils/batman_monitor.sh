#!/bin/bash



sudo batctl o -H | awk '{print $1" "$2" "$3" "$4}'
echo;echo;
sudo batctl o -H | wc -l | awk '{print $1 + 1}'

echo;echo;
echo $(date +%x_%r)
echo ----------------

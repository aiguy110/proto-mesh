#!/bin/bash


echo "{\"datapoint\" : { "
echo "\"timestamp\": \"" $(date +%x_%r) "\" ,"
echo "\"HostMAC\" : " $(ifconfig | grep wlan0 | awk '{ print $5 }') " ,"
echo "'oriiginators' : {"
sudo batctl o -t 10 -H | awk '{ gsub("\("," "); gsub("\)"," ");  printf "{\"node\": { \"mac\": %s,  \"lastHeard\":  %s, \"signal\": %s,  \"nextHop\": %s }},\n", $1, $2, $3, $4  }'
echo " },"
echo "'neighbors' : {"
sudo batctl n 10 -H | awk '{ printf "{ \"neighbor\": {\"mac\": %s, \"lastHeard\": %s }},\n", $2, $3 }'
echo " },"
echo "\"totalNodes\" : " $(sudo batctl o -t 10 -H | wc -l | awk '{ printf ($1 + 1) }') " ,"
echo "\"wlan0Config\" : {"
echo "\"batmanInterval\" : " $(sudo batctl it) " ,"
echo "\"txpower\" : " $(iwlist txpower 2> /dev/null | grep Current | awk '{ gsub("="," "); print $3" "$4 }') " ,"
echo "\"freq\" : " $(iwlist wlan0 frequency 2> /dev/null | grep Current | awk '{ gsub(":"," "); print $3" "$4}')
echo " } "
echo " },"



#!/bin/bash

# ssh into all linux devices
user='pi'
pass='raspberry'


# IP List
#Create file of local ubuntu ips
#avahi-browse -tl _workstation._tcp | grep IPv4 | awk '{print $4}' > local_ips.txt


#read file line by line
while read ip; do
	#connect each machine
	echo "ssh into $ip..."
	sshuser="sshpass -p $pass ssh -tt -X $user@$ip.local"
	xterm -title $ip -e $sshuser &
done < local_ips.txt

echo "Connecting $host..."
xterm -title $host &



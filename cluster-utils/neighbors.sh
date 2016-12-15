#/!bin/bash

FILE="~/neighbors.txt"


sudo ./command_all.sh "sudo ifconfig wlan0 | grep wlan0 | awk '{ print \$5 }' > $FILE && echo >> $FILE &&  sudo batctl n -H | awk '{print \$2}' >> $FILE"

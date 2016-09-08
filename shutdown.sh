kill $(ps -ef | grep kad | grep daemon | awk '{print $2}')
modprobe -r batman-adv

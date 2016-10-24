# Write a list of batman node IP addresses to a file
python3 batnodesToFile4.py node_addrs.txt

# Start KadNode using that list
kadnode --ifname bat0 --mode ipv4 --peerfile node_addrs.txt --value-id $1 --daemon
if [ $? == 0 ]; then
   echo "Kadnode started successfully!"
else
   echo "Kadnode experienced and error..."
fi

# Insure peers
while true; do
   PEERCOUNT=$(kadnode-ctl status | grep "DHT Nodes" | awk '{print $3}')
   if [ $PEERCOUNT == '0' ]; then
      echo "Searching for a Kadnode peer..."
      while read ADDR; do
         echo "Attempting to connect to $ADDR"
         kadnode-ctl import $ADDR > /dev/null
      done <node_addrs.txt
      sleep 5
   else
      echo 'Kadenode peer found!'
      break
   fi
done

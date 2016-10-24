# This script hangs until other batman nodes are detected
while true; do
   python3 batnodesToFile4.py node_addrs.txt
   if [ -s node_addrs.txt ]; then
      break
   fi
   echo "Waiting to connect to a neighbor..."
   sleep 5
done


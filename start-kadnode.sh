# Write a list of batman node IP addresses to a file
python3 batnodesToFile4.py node_addrs.txt

# Start KadNode using that list
kadnode --ifname bat0 --mode ipv4 --peerfile node_addrs.txt --daemon

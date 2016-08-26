# IF NOT ALREADY PRESENT Get a list of all BATMAN node ipv6 addresses written to a file
if [ ! -f node_addrs.txt ]; then 
   python3 batnodesToFile.py node_addrs.txt
fi

# Start KadNode using that list
kadnode --ifname bat0 --mode ipv6 --peerfile node_addrs.txt --daemon

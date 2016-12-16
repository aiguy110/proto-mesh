from subprocess import check_output
import sys
import hashlib
import struct

def macToIPv4(mac):
   sha = hashlib.sha1()
   sha.update(mac.encode('utf-8'))
   h = sha.digest()
   host_id = struct.unpack('BB', h[0:2])
   return '10.0.'+str(host_id[0])+'.'+str(host_id[1])

def macToIPv6(mac):
   mac=''.join( filter(lambda x:x!=':', mac) )
   return 'fe80:bbbb::'+mac[:4]+':'+mac[4:8]+':'+mac[8:]

def listBatmanMACs():
   lines = check_output('batctl o -t 50', shell=True).decode('ascii').split('\n')
   for row in lines[2:-1]:
      if row[:2] == 'No':
         continue
      yield(row[:17])

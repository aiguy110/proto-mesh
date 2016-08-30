from subprocess import check_output
import sys


def macToIPv6(mac):
   mac=''.join( filter(lambda x:x!=':', mac) )
   return 'fe80::'+mac[:4]+':'+mac[4:8]+':'+mac[8:]

def listBatmanMACs():
   lines = check_output('batctl o', shell=True).decode('ascii').split('\n')
   for row in lines[2:-1]:
      yield(row[:17]+'%bat0')

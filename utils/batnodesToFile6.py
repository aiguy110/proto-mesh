import sys
import address_helper

if __name__ == '__main__':
   macs = address_helper.listBatmanMACs()
   with open(sys.argv[1], 'w') as f:
      for mac in macs:
         f.write(address_helper.macToIPv6(mac)+'%bat0\n')

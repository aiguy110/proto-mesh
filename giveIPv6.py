from subprocess import call, check_output
import sys

if __name__ == '__main__':
   # Get MAC address of interface
   iface = sys.argv[1]
   macStr = ''
   with open('/sys/class/net/'+iface+'/address') as f:
      macStr = f.read().strip()
   macNum = 0
   hexDig=0
   for char in macStr[::-1]:
      if char == ':':
         continue
      else:
         value = '0123456789abcdef'.find(char)
         macNum += 16**hexDig * value
         hexDig += 1
   
   # Generate an IPv6 address from the MAC address
   ipv6Num = 0xfe800000000000000000000000000000 + macNum
   ipv6Str = ''
   for hexDig in range(32):
      if hexDig % 4 == 0 and hexDig != 0:
         ipv6Str += ':'
      mask = 15 * 2**(4*hexDig)
      value = (ipv6Num & mask) // (2**(4*hexDig))
      ipv6Str += '0123456789abcdef'[value] 
   ipv6Str=ipv6Str[::-1]+'/64'
 
   # Apply this IPv6 address to the interface
   check_output('ip -6 addr add '+ipv6Str+' dev '+iface, shell=True)

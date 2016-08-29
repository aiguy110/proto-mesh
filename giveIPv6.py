from subprocess import call, check_output
import sys

if __name__ == '__main__':
   # Get MAC address of interface
   iface = sys.argv[1]
   iface2 = None
   if len( sys.argv ) == 3:
      iface2 = sys.argv[2]
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
 
   # Apply this IPv6 address to the interface.
   # If we recieved a second interface argument apply
   # it to that one instead.
   iface_to = iface
   if iface2:
      iface_to = iface2
   check_output('ip addr flush dev '+iface_to, shell=True)
   check_output('ip -6 addr add '+ipv6Str+' dev '+iface_to, shell=True)

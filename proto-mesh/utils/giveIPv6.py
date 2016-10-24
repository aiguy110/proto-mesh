from subprocess import call, check_output
import address_helper 
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
   
   # Deterministically generate an IPv6 address from the MAC address
   ipv6Str = address_helper.macToIPv6(macStr)+'/64'
   
   # Apply this IPv6 address to the interface.
   # If we recieved a second interface argument apply
   # it to that one instead.
   iface_to = iface
   if iface2:
      iface_to = iface2
   check_output('ip addr flush dev '+iface_to, shell=True)
   check_output('ip -6 addr add '+ipv6Str+' dev '+iface_to, shell=True)

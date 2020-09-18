#/usr/bin/env bash

set -Eeu

#if [ "$UID" -ne 0 ]; then
	#echo "Please run as root"
	#exit
#fi

# the 4G modem WAN
WANIF="eth1"

# the Pi's RJ45 port
# the device connected to this port should set a static IP in 192.168.3.0/24
LANIF="eth0"

# establish NAT between eth0 and eth1
iptables -t nat -A POSTROUTING -o $WANIF -j MASQUERADE

WANGATEWAY=$(ip route show 0.0.0.0/0 dev $WANIF | cut -d\  -f3)

ip rule add iif $LANIF priority 48010 table 3
ip route add default via $WANGATEWAY dev $WANIF table 3

# disable default route on eth1
# this way the Pi won't try to connect through the LTE stick
ip route delete default dev $WANIF

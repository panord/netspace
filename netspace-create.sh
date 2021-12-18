#!/bin/bash
usage()
{
	echo -e "netspace - the quick and dirty network namespace for"
	echo -e "your embedded needs.\n"
	echo -e "usage: netspace.sh IFACE IPADDR [ NS ]\n"
	echo -e "FILES:"
	echo -e "\t~/.config/netspace/ctl.sh	is executed in namespace after start/stop"
}

dev=$1
addr=$2
ns=$3
if [ -z "$dev" ] || [ -z "$addr" ]; then
	usage
	exit 1
fi

if [ -z "$ns" ]; then
	ns=netspace
fi

if [ $EUID != 0 ]; then
	echo "Netspace requires elevated privileges"
	exit 1
fi

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
if ! ip netns add $ns ; then
	echo "Failed to create $ns"
	exit 1
fi

ip link set dev $dev netns $ns
ip netns exec $ns ip link set lo up
ip netns exec $ns ip link set dev $dev up
ip netns exec $ns ip addr add dev $dev $addr
ip netns exec $ns ip route add default dev $dev

$USER_HOME/bin/netspace-ctl.sh start $ns

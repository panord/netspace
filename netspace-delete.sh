#!/bin/bash
usage()
{
	echo -e "usage: netspace-delete.sh NAME"
}

if [ -z "$ns" ]; then
	ns=netspace
fi

if [ $EUID != 0 ]; then
	echo "Netspace requires elevated privileges"
	exit 1
fi

ip netns del $ns


#!/bin/bash
usage()
{
	echo -e "netspace - the quick and dirty network namespace for"
	echo -e "your embedded needs.\n"
	echo -e "usage: netspace.sh COMMAND [OPTS]\n"
	echo -e "COMMAND:"
	echo -e "	create IFACE IPADDR [ NS ]"
	echo -e "	delete [NS]"
	echo -e "FILES:"
	echo -e "\t~/.config/netspacectl.sh start creation"
}

if [ $EUID != 0 ]; then
	echo "Netspace requires elevated privileges"
	exit 1
fi

if [ -z "$@" ]; then
	usage
	exit 0
fi

cmd=$1
shift;
case $cmd in
	create)
		dev=$1
		addr=$2
		ns=$3

		if [ -z "$ns" ]; then
			ns=netspace
		fi

		if ! ip netns add $ns ; then
			echo "Failed to create $ns, $?"
			exit 1
		fi

		ip netns exec $ns ip link set lo up
		if [ ! -z "$dev" ]; then
			ip link set dev $dev netns $ns
			ip netns exec $ns ip link set dev $dev up
			ip netns exec $ns ip route add default dev $dev

			if [ ! -z "$addr" ]; then
				ip netns exec $ns ip addr add dev $dev $addr
			fi
		fi
	;;
	del|delete)
		ns=$1
		if [ -z "$ns" ]; then
			ns=netspace
		fi

		# TODO: It might be nice if some information about the setup
		# above is saved so that it can be 'reversed' on a delete.
		# in particular, any interfaces which are moved can be moved
		# back.
		ip netns del $ns
	;;
	*)
		echo "Unrecognized command $cmd"
		usage
		exit 1
	;;
esac

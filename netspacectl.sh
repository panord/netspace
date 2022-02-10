#!/bin/bash
ns=$1
cmd=$2
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

usage()
{
	echo -e "usage: $0 COMMAND [OPTS]\n"
	echo "COMMANDS"
	echo "	start 	[NAMESPACE]"
	echo "	stop 	[NAMESPACE]"
	echo "	ps	[NAMESPACE]"
	echo "	enter 	[NAMESPACE]"
}

if [ -z "$cmd" ]; then
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

case $cmd in
	enter)
		ip netns exec $2 runuser -u $SUDO_USER bash
	;;
	start)
		export NAME="$ns"
		/etc/netspace/init.sh
	;;
	stop)
		for p in $(sudo ip netns pids $ns); do
			echo "Stopping $p"
			kill -SIGKILL $p
		done
	;;
	ps)
		for p in $(sudo ip netns pids $ns); do
			ps aux | grep $p | head -n 1
		done
	;;
	*)
		echo "Unrecognized command $cmd"
		exit 1
	;;
esac

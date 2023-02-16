environment:
	@echo "Run 'make config' first!"
	@exit 0

config:
	ip link
	@if read -p "Which network interface to use: " iface; then 	\
		if ! ip link show "$$iface" 2>/dev/null; then		\
			echo "Invalid network interface";		\
			exit 1;						\
		fi;							\
		echo "IFACE=$$iface" > environment;			\
	fi
	@read -p "Which network adress to use? (192.168.10.99/24): " addr; \
	if [ -z "$$addr" ]; then					\
		addr="192.168.10.99/24";					\
	fi;								\
	echo "IPADDR=$$addr" >> environment
	@read -p "Name your netspace (netspace): " name;		\
	if [ -z "$$name" ]; then					\
		name="netspace";					\
	fi;								\
	echo "NAME=$$name" >> environment


install: environment
	mkdir -p /etc/netspace
	cp *.sh /usr/sbin
	cp -fr netspace/* /etc/netspace/
	if test -f /lib/systemd/systemd; then \
		cp netspace.service /lib/systemd/system/; \
	fi
	cp environment /etc/netspace/

.PHONY: install config

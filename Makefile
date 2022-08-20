install:
	mkdir -p /etc/netspace
	cp *.sh /usr/sbin
	cp -fr netspace/* /etc/netspace/
	if test -f /lib/systemd/systemd; then \
		cp netspace.service /lib/systemd/system/; \
	fi

.PHONY: install

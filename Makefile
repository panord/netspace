install:
	mkdir -p /etc/netspace
	cp *.sh /usr/sbin
	cp -fr netspace/* /etc/netspace/

.PHONY: install

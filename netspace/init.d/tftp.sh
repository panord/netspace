#!/bin/sh
mkdir -p /srv/tftp
chown root:tftp /srv/tftp
$START /usr/sbin/in.tftpd --listen --user tftp --address :69 --secure /srv/tftp

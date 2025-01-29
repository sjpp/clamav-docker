#!/bin/sh
set -e

# Configure ClamAV
sed -i "s/\$CLAMAV_TCPADDRESS/$CLAMAV_TCPADDRESS/g" /etc/clamav/clamd.conf
sed -i "s/\$CLAMAV_TCPPORT/$CLAMAV_TCPPORT/g" /etc/clamav/clamd.conf

# Make sure Clamd environment exists
if [ ! -d /run/clamav ]
then
    mkdir /run/clamav
    chmod 755 /run/clamav
    touch /run/clamav/clamd.ctl
    chown -R clamav:clamav /run/clamav
fi

cron

exec "$@"

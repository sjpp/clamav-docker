#!/bin/sh
set -e

# Make sure Clamd environment exists
if [ ! -d /run/clamav ]
then
    mkdir /run/clamav
    chmod 755 /run/clamav
    touch /run/clamav/clamd.ctl
    chown -R clamav:clamav /run/clamav
fi

crond

exec "$@"
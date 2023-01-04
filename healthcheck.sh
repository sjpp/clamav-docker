#!/bin/sh

_APP="CLAMAV"
_PORT=3310

if [ ! -z "$(ss -Hl "( sport = :$_PORT )")" ] ; then
	echo "$_APP: listening on port $_PORT"
else
	echo "$_APP: not listening, check logs for errors"
	exit 1
fi

#!/bin/sh
#

interface=$1
event=$2

if [ "$event" = "up" -a "$CONNECTION_EXTERNAL" = "1" ]; then
	if [ -e /proc/net/pnp ]; then
		echo "NetworkManager using resolvconf to handle /proc/net/pnp for $interface"
		resolvconf -a $interface -f </proc/net/pnp
	fi
fi

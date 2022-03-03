#!/bin/bash

__tmpfile=$(mktemp)
curl -L ivpn.net -o ${__tmpfile} &> /dev/null

if grep -i "connected to ivpn" ${__tmpfile}  &> /dev/null; then 
	echo "Connected"
else 
	echo "NOT Connected"
fi

shred -u ${__tmpfile}

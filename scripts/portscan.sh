#!/bin/bash

## Simple nmap port scanner
## Check if argument was given, if not, print usage

target=$1

if [[ -z "$target" ]]
then
	echo "[*] Simple nmap port scanning script."
	echo "[*] Usage   : $0 <target> "
	exit 0
fi

##
## TCP
##
echo ""
echo "Target: " $target
echo ""
echo "+--------------------+"
echo "|  _____ ____ ____   |"
echo "| |_   _/ ___|  _ \  |"
echo "|   | || |   | |_) | |"
echo "|   | || |___|  __/  |"
echo "|   |_| \____|_|     |"
echo "|                    |"
echo "+--------------------+"
echo ""
echo "Scanning for open TCP ports..."
#  Comma separated list of tcp ports
tcpports=$(sudo nmap --privileged -Pn -p 1-65535 -sS --min-rate=1000 -T4 $target 2>/dev/null | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')

#  Check to see if there were any open ports
if [[ -z "$tcpports" ]]
then
	echo "No open TCP ports detected."
else
	#  Initial scan for open TCP ports
	echo "Running default scripts and version detection against following open TCP ports: " $tcpports
	echo ""
	sudo nmap --privileged -Pn -sC -sV -p$tcpports $target 2>/dev/null
fi
echo "TCP logic complete."

##
## UDP
##
echo ""
echo "Target: " $target
echo ""
echo "+---------------------+"
echo "|  _   _ ____  ____   |"
echo "| | | | |  _ \|  _ \  |"
echo "| | | | | | | | |_) | |"
echo "| | |_| | |_| |  __/  |"
echo "|  \___/|____/|_|     |"
echo "|                     |"
echo "+---------------------+"
echo ""
echo "Scanning for open UDP ports..."
# Comma separated list of udp ports
udpports=$(sudo nmap --privileged -Pn -p 1-65535 -sU --min-rate=1000 -T4 $target 2>/dev/null | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')

#  Check to see if there were any open ports
if [[ -z "$udpports" ]]
then
	echo "No open UDP ports detected."
else
	#  Initial scan for open UDP ports
	echo "Running default scripts and version detection against following open UDP ports: " $udpports
	echo ""
	sudo nmap --privileged -Pn -sC -sV -p$udpports $target 2>/dev/null
fi
echo "UDP logic complete."
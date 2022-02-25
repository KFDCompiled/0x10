#!/bin/bash

if [[ "$#" -ne 0 ]]; then
	echo -ne "\n[*]\tShell script for quick overview of open ports"
	echo -ne "\n[*]\tUSAGE:\t$0\n"
	exit 1
else
	if [[ -f scans/xml/_full_tcp_nmap.xml ]]; then
		echo $(xmlstarlet select -t -v "count(/nmaprun/host/ports/port)" scans/xml/_full_tcp_nmap.xml) open TCP ports.
		echo -ne "TCP PORT\tSERVICE\t\tPRODUCT\n"
    for port in $(xmlstarlet select -t -v '/nmaprun/host/ports/port/@portid' scans/xml/_full_tcp_nmap.xml); do
        if [[ "${#port}" -lt 4 ]]; then
            echo -ne "    $port\t\t$(xmlstarlet select -t -v "/nmaprun/host/ports/port[@portid=$port]/service/@name" scans/xml/_full_tcp_nmap.xml)\t\t$(xmlstarlet select -t -v "/nmaprun/host/ports/port[@portid=$port]/service/@product" scans/xml/_full_tcp_nmap.xml)\n"
        else
            echo -ne "    $port\t$(xmlstarlet select -t -v "/nmaprun/host/ports/port[@portid=$port]/service/@name" scans/xml/_full_tcp_nmap.xml)\t\t$(xmlstarlet select -t -v "/nmaprun/host/ports/port[@portid=$port]/service/@product" scans/xml/_full_tcp_nmap.xml)\n"
        fi
    done
		exit 0
	else
		echo -ne "\n[*]\tERROR: cannot find $PWD/scans/xml/_full_tcp_nmap.xml!\n[*]\tExiting...\n"
		exit 1
	fi
fi

#!/bin/bash

if [[ "$#" -ne 0 ]]; then
	echo -ne "\n[*]\tShell script for quick overview of open ports"
	echo -ne "\n[*]\tUSAGE:\t$0\n"
	exit 1
else
	if [[ -f scans/xml/_full_tcp_nmap.xml ]]; then
		onetab="\t"
		twotab="\t\t"
		echo -ne "\nHost $(xmlstarlet select -t -v "/nmaprun/@args" scans/xml/_full_tcp_nmap.xml | grep -o '[^ ]*$') has $(xmlstarlet select -t -v "count(/nmaprun/host/ports/port)" scans/xml/_full_tcp_nmap.xml) open TCP ports.\n"
		echo -ne "TCP PORT\tSERVICE\t\tPRODUCT\n"
		for port in $(xmlstarlet select -t -v '/nmaprun/host/ports/port/@portid' scans/xml/_full_tcp_nmap.xml); do
			
			if [[ "${#port}" -lt 4 ]]; then
				porttoservicetabs=$twotab
			else
				porttoservicetabs=$onetab
			fi

			service=$(xmlstarlet select -t -v "/nmaprun/host/ports/port[@portid=$port]/service/@name" scans/xml/_full_tcp_nmap.xml)
			if [[ "${#service}" -lt 6 ]]; then
				servicetoproducttabs=$twotab
			else
				servicetoproducttabs=$onetab
			fi

			product=$(xmlstarlet select -t -v "/nmaprun/host/ports/port[@portid=$port]/service/@product" scans/xml/_full_tcp_nmap.xml)

			echo -ne "    $port$porttoservicetabs$service$servicetoproducttabs$product\n"
		done
	else
		echo -ne "\n[*]\tERROR: cannot find $PWD/scans/xml/_full_tcp_nmap.xml!\n[*]\tSkipping...\n"
	fi

	if [[ -f scans/xml/_top_100_udp_nmap.xml ]]; then
		onetab="\t"
		twotab="\t\t"
	    echo -ne "\nHost $(xmlstarlet select -t -v "/nmaprun/@args" scans/xml/_top_100_udp_nmap.xml | grep -o '[^ ]*$') has $(xmlstarlet select -t -v "count(/nmaprun/host/ports/port)" scans/xml/_top_100_udp_nmap.xml) open UDP ports.\n"
	    echo -ne "UDP PORT\tSERVICE\t\tPRODUCT\n"
		for port in $(xmlstarlet select -t -v '/nmaprun/host/ports/port/@portid' scans/xml/_top_100_udp_nmap.xml); do

			if [[ "${#port}" -lt 4 ]]; then
				porttoservicetabs=$twotab
			else
			    porttoservicetabs=$onetab
			fi

			service=$(xmlstarlet select -t -v "/nmaprun/host/ports/port[@portid=$port]/service/@name" scans/xml/_top_100_udp_nmap.xml)
			if [[ "${#service}" -lt 6 ]]; then
				servicetoproducttabs=$twotab
			else
				servicetoproducttabs=$onetab
			fi

			product=$(xmlstarlet select -t -v "/nmaprun/host/ports/port[@portid=$port]/service/@product" scans/xml/_top_100_udp_nmap.xml)

			echo -ne "    $port$porttoservicetabs$service$servicetoproducttabs$product\n"
		done
	else
	    echo -ne "\n[*]\tERROR: cannot find $PWD/scans/xml/_top_100_udp_nmap.xml!\n[*]\tSkipping...\n"
	fi
fi

#!/bin/bash

if [[ "$#" -ne 1 ]]; then
	echo -ne "\n[*]\tShell script to check ports 139 & 445 for common samba vulns"
	echo -ne "\n[*]\tUSAGE:\t$0 host\n"
	exit 1
else
	TARGETPORTARRAY=("139" "445")
	MSVULNYRNUMARRAY=("ms06-025" "ms07-029" "ms08-067" "ms17-010")
	__TARGETIPV4=$1
	for __TARGETPORT in ${TARGETPORTARRAY[@]}; do
		for __MSVULNYRNUM in ${MSVULNYRNUMARRAY[@]}; do
			sudo nmap -vv --reason -Pn -T4 -sV -p $__TARGETPORT --script="smb-vuln-$__MSVULNYRNUM" --script-args="unsafe=1" $__TARGETIPV4
		done
	done
	exit 0
fi

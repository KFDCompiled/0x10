#!/bin/bash

(( 16#$1 )) > /dev/null 2>&1
if [[ $? -ne 0 ]] || [[ "$#" -ne 1 ]]; then
	echo -ne "\n[*]\tConvert hexadecimal  IPv4 to dotted decimal.\n[*]\tUSAGE: $0 <hexadecimal ipv4>\n"
    exit 1
else
	printf "%d." $(echo $1 | sed 's/../0x& /g' | tr ' ' '\n' | tac | sed 's/\.$/\n/') | awk -F "." '{print $4 "." $3 "." $2 "." $1}'
fi
	

#!/bin/bash

re='^[0-9]+$'
nd="${#1}"
if [[ "$#" -ne 1 ]] || ! [[ $1 =~ $re ]] || [[ $nd -ne 17 ]]; then
	echo -ne "\n[*]\tConvert 17 digit Chrome/WebKit time to localtime\n[*]\tUSAGE: $0 <17-digit webkit time>\n"
	exit 1
else
	d1=$(date +%s -d 'Jan 1 00:00:00 UTC 1601')
	d2=$(bc -l <<< $1/1000000 | sed -e 's/[0]*$//g')
	diffsecs=$(bc -l <<< $d1+$d2)
	TZ='US/Mountain' date -d @$diffsecs +"%a %d %b %Y %T %p %Z"
fi

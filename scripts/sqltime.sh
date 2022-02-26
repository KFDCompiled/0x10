#!/bin/bash

re='^[0-9]+$'
__front=$(echo $1 | cut -d. -f1)
__back=$(echo $1 | cut -d. -f2)
frontnd="${#__front}"
backnd="${#__back}"
if [[ "$#" -ne 1 ]] || ! [[ $__front =~ $re ]] || ! [[ $__back =~ $re ]] || [[ $frontnd -ne 10 ]] || [[ $backnd -ne 6 ]]; then
	echo -ne "\n[*]\tConvert 10-digit.6-digit SQL time to localtime\n[*]\tUSAGE: $0 <10-digit.6-digit sql time>\n"
	exit 1
else
	TZ='US/Mountain' date -d @$__front.$__back +"%a %d %b %Y %T %p %Z"
fi

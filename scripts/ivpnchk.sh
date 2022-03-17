#!/bin/bash

BOLD="\e[1m"
UNDER="\e[4m"
FGC="\e[38;5;"
BGC="\e[48;5;"
NC="\e[0m"

__dbgfile=$(mktemp).DEBUG
__tmpfile=$(mktemp)

__handler=$__tmpfile

curl -L ivpn.net -o ${__handler} &> /dev/null

# echo -ne "\n[i]\tLine: $(awk '/connected to IVPN/' ${__handler})"
__key=$(awk '/connected to IVPN/ {print $3}' ${__handler})
# echo -ne "\n[i]\tKey: ${__key}\n"

if  [ $__key == "connected" ] ; then
	echo -ne "\n[i]\t${UNDER}Connected${NC}\n"
elif [ $__key == "not" ] ; then
	echo -ne "\n[i]\t${BOLD}NOT${NC} Connected\n"
else
	echo -ne "\n[!]\tUnexpected result!\n[!]\n[!]\tLine: $(awk '/connected to IVPN/' ${__handler})\n[!]\tKey: ${__key}\n[!]\tCheck ${__handler} if it exists.\n"
fi

if [[ -f $__tmpfile ]]; then shred -u ${__tmpfile}; fi
if [[ -f $__dbgfile ]]; then echo -ne "\n[i]\t${__dbgfile}\n"; fi

#
# KFD penetration testing zshrc template
#
# depends on grepcidr

# Stage user-defined engagement variables
__vpniface=tun0
__targethostname=legacy.htb
__targetipv4=10.129.255.243
__localhostipv4=10.10.14.28


# Ascii 
# use following sed command to escape symbols (backticks, double quotes, and dollar signs)
# sed -e 's/`/\\`/g' -e 's/"/\\"/g' -e 's/\$/\\\$/g'
#
BOLD="\e[1m"
ITAL="\e[3m"
UNDER="\e[4m"
REVERSE="\e[7m"
STRIKE="\e[9m"
FGC="\e[38;5;"
BGC="\e[48;5;"
NC="\e[0m"

function ddtohex() {
	local xoct_one=$(printf "%x" $(echo $1 | cut -d "." -f 1))
	local xoct_two=$(printf "%x" $(echo $1 | cut -d "." -f 2))
	local xoct_three=$(printf "%x" $(echo $1 | cut -d "." -f 3))
	local xoct_four=$(printf "%x" $(echo $1 | cut -d "." -f 4))
	local xip="${xoct_one}${xoct_two}${xoct_three}${xoct_four}"
	echo -ne "${xip}"
}

function nojoy() {
  NEUTRALCOLORARRAY=("15m" "252m" "248m" "244m" "240m" "236m")
  index=0
  for color in ${NEUTRALCOLORARRAY[@]}; do
    eval "FGNEU$index=\"${FGC}${color}\""
    ((index=index+1))
  done

  printf """
  ${FGNEU0}:::.    :::.    ...             ....::::::   ...  .-:.     ::-.
  ${FGNEU1}\`;;;;,  \`;;; .;;;;;;;.       ;;;;;;;;;\`\`\`\`.;;;;;;;.';;.   ;;;;'
  ${FGNEU2}  [[[[[. '[[,[[     \[[,     ''\`  \`[[.   ,[[     \[[,'[[,[[['  
  ${FGNEU3}  \$\$\$ \"Y\$c\$\$\$\$\$,     \$\$\$    ,,,    \`\$\$   \$\$\$,     \$\$\$  c\$\$\"    
  ${FGNEU4}  888    Y88\"888,_ _,88P    888boood88   \"888,_ _,88P,8P\"\`     
  ${FGNEU5}  MMM     YM  \"YMMMMMP\"     \"MMMMMMMM\"     \"YMMMMMP\"mM\"        ${NC}
  """
}

function targetlock() {
  REDCOLORARRAY=("233m" "52m" "88m" "124m" "160m" "1m")
  index=0
  for color in ${REDCOLORARRAY[@]}; do
    eval "FGRED$index=\"${FGC}${color}\""
    ((index=index+1))
  done

  printf """
  ${FGRED0}:::::::::::::::.    :::::::..    .,-:::::/ .,::::::::::::::::::
  ${FGRED1};;;;;;;;'''';;\`;;   ;;;;\`\`;;;; ,;;-'\`\`\`\`'  ;;;;'''';;;;;;;;''''
  ${FGRED2}     [[    ,[[ '[[,  [[[,/[[[' [[[   [[[[[[/[[cccc      [[     
  ${FGRED3}     \$\$   c\$\$\$cc\$\$\$c \$\$\$\$\$\$c   \"\$\$c.    \"\$\$ \$\$\"\"\"\"      \$\$     
  ${FGRED4}     88,   888   888,888b \"88bo,\`Y8bo,,,o88o888oo,__    88,    
  ${FGRED5}     MMM   YMM   \"\"\` MMMM   \"W\"   \`'YMUP\"YMM\"\"\"\"YUMMM   MMM    
  ${FGRED5} :::         ...       .,-:::::  :::  .   .,:::::::::::::-.    
  ${FGRED4} ;;;      .;;;;;;;.  ,;;;'\`\`\`\`'  ;;; .;;,.;;;;'''' ;;,   \`';,  
  ${FGRED3} [[[     ,[[     \[[,[[[         [[[[[/'   [[cccc  \`[[     [[  
  ${FGRED2} \$\$'     \$\$\$,     \$\$\$\$\$\$        _\$\$\$\$,     \$\$\"\"\"\"   \$\$,    \$\$  
  ${FGRED1}o88oo,.__\"888,_ _,88P\`88bo,__,o,\"888\"88o,  888oo,__ 888_,o8P'  
  ${FGRED0}\"\"\"\"YUMMM  \"YMMMMMP\"   \"YUMMMMMP\"MMM \"MMP\" \"\"\"\"YUMMMMMMMP\"\`    ${NC}
  """
}

# Check to see if environment is clean
# Attack flag string value comes from `echo -ne "ATTACK FLAG" | base64`
echo -ne "Attack flag "
if [[ -z "$QVRUQUNLIEZMQUc" ]]; then
	echo -ne "is down.  "
	# Environment is clean, load user-defined variables from staging
	vpniface=$__vpniface
	targethostname=$__targethostname
	targetipv4=$__targetipv4
	localhostipv4=$__localhostipv4
	localhostipv4hex=printf"%x"
elif [[ "$QVRUQUNLIEZMQUc" ]]; then
	echo -ne "exists and"
	if [ $(printenv QVRUQUNLIEZMQUc) -eq 1 ]; then
		echo -ne " is already up!\n"
		# Environment is not clean
		echo -ne "Environment variables:\t\tTARGETIP\t\tLHOST\nUser-Defined:\t\t\t$__targetipv4\t\t$__localhostipv4\nCurrent:\t\t\t$TARGET\t\t$LHOST"
		return 1
	else
		echo -ne "Attack Flag is $QVRUQUNLIEZMQUc.\nExiting...\n"
		return 1
	fi
else
	echo -ne "Attack Flag is $QVRUQUNLIEZMQUc.\nExiting...\n"
	return 1
fi

echo -ne "Setting up environment:\n"
# Check if correct VPN interface is being used
echo -ne "Checking for presence of user-specified vpn interface $vpniface . . . "
iface=$(ip link | grep -v 'lo\|eth0\|link' | awk '{print $2}' | cut -d ":" -f 1)
if [[ $iface == $vpniface ]]; then
	echo -ne " found $iface.\n"
	vpnlocalipv4=$(ip addr show $vpniface | grep -w inet | awk '{print $2}' | cut -d "/" -f 1)
else
	echo "VPN interface variable vpniface is set to $vpniface but detected interface is $iface."
	echo "Exiting..."
	return 1
fi

# Export environment variables
echo -ne "Exporting environment variables . . ."
# Make sure there's a route to target using vpn interface
vpncidr=$(ip route | awk -v awkvar="$vpniface" '$0 ~ awkvar && /via/ {print $1}' | sed -z 's/\n/,/g;s/,$/\n/')
grepcidr $vpncidr <<< $targetipv4 > /dev/null
if [ $? -eq 0 ]; then
	echo -ne " TARGET=$targetipv4 . . ."
	export TARGET=$targetipv4
else
	echo "Target IP $targetipv4 is missing from vpn interface $vpniface subnets $vpncidr."
	echo "Exiting..."
	return 1
fi

# Make sure that localhost IP is using vpn interface
if [[ $localhostipv4 == $vpnlocalipv4 ]]; then
	echo -ne " LHOST=$vpnlocalipv4 . . ."
	export LHOST=$vpnlocalipv4
else
	echo "Localhost IP variable localhostipv4 is set to $localhostipv4 but vpn local address is $vpnlocalipv4."
	echo "Exiting..."
	return 1
fi

echo -ne " done.\n"

# Raise attack flag
echo -ne "Raising attack flag . . ."
export QVRUQUNLIEZMQUc=1
echo -ne " done.\n"

# Aliases
echo -ne "Setting aliases . . ."
alias autorecon='sudo env "PATH=$PATH" autorecon'
echo -ne " done.\n"

# Functions
echo -ne "Loading functions . . ."
function cas() {
	if [[ -z "$QVRUQUNLIEZMQUc" ]]; then
		nojoy
		return 1
	elif [[ "$QVRUQUNLIEZMQUc" ]]; then
		if [ $(printenv QVRUQUNLIEZMQUc) -eq 1 ]; then
			targetlock
			echo -ne "TARGET=$TARGET\t\t\tLHOST=$LHOST\n"
			return 0
		else
			echo -ne "Attack Flag is $QVRUQUNLIEZMQUc.\nExiting...\n"
			return 1
		fi
	else
		echo -ne "Attack Flag is $QVRUQUNLIEZMQUc.\nExiting...\n"
		return 1
	fi
}
echo -ne " done.\n"

# Logging
DTG=$(TZ='America/Denver' date +"%Y%b%d_%H%M%S%Z")
echo -ne "Touching timestamped configuration /tmp/QVRUQUNLIEZMQUc-$DTG . . ."
touch /tmp/QVRUQUNLIEZMQUc-$DTG
echo -ne " done. Copying environment variables into timestamped configuration . . ."
echo -ne "NAME\t$targethostname\n" > /tmp/QVRUQUNLIEZMQUc-$DTG && echo -ne "TARGET\t$TARGET\n" >> /tmp/QVRUQUNLIEZMQUc-$DTG && echo -ne "LHOST\t$LHOST\n" >> /tmp/QVRUQUNLIEZMQUc-$DTG
echo -ne " done.\n\nHappy hacking!\n"

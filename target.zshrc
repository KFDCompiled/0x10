#
# KFD penetration testing zshrc template
#
# depends on grepcidr & pentest.zshrc_functions

# Stage user-defined engagement variables
__vpniface=tun0
__targethostname=
__targetipv4=
__localhostipv4=


# Variables
DTG=$(TZ='America/Denver' date +"%Y%b%d_%H%M%S%Z")
PWD=$(pwd)
CONFIGFILE=$PWD/.QVRUQUNLIEZMQUc

# Check to see if environment is clean
echo -ne "Examining environment.  "
# ATTACKFLAG string value comes from `echo -ne "ATTACK FLAG" | base64`
echo -ne "Attack flag "
if [[ -z "$QVRUQUNLIEZMQUc" ]]; then
	echo -ne "is down"
	if [[ "$TARGET" ]] || [[ "$LHOST" ]]; then
		# environment variables are set
		echo -ne " but environment variable TARGET is $TARGET LHOST is $LHOST"
		echo -ne "!\nExiting..."
		return 1
	else 
		# all environment variables are empty
		echo -ne ".  "
	fi

	# Check whether there's an existing configuration file
	if [[ -f $CONFIGFILE ]]; then
		# Directory from which script is being run has a configuration file
		echo -ne "But, there is configuration file .QVRUQUNLIEZMQUc in $PWD with values:\n"
		# parseconfig is function in pentest.zshrc_functions
		parseconfig $CONFIGFILE
		echo -ne "Exiting... "
		return 1
	else
		# Directory from which script is being run is clean (does not have a configuration file)
		# load user-defined variables into staging
		echo -ne "Loading user-defined variables into staging . . . "
		vpniface=$__vpniface
		targethostname=$__targethostname
		targetipv4=$__targetipv4
		localhostipv4=$__localhostipv4
		echo -ne "done.  "
	fi
elif [[ "$QVRUQUNLIEZMQUc" ]]; then
	# ATTACKFLAG exists
	echo -ne "exists and"
	if [ $(printenv QVRUQUNLIEZMQUc) -eq 1 ]; then
		# ATTACKFLAG set to 1
		echo -ne " is already up"
		if [[ -f $CONFIGFILE ]]; then
			# Directory from which script is being run has a configuration file
			echo -ne " and there is a configuration file .QVRUQUNLIEZMQUc in $PWD with values:\n"
			# parseconfig is function in pentest.zshrc_functions
			parseconfig $CONFIGFILE
			echo -ne "!\nEnvironment variables:\t\tTARGETIP\t\tLHOST\nUser-Defined:\t\t\t$__targetipv4\t\t$__localhostipv4\nCurrent:\t\t\t$TARGET\t\t$LHOST"
			return 1
		else
			# Directory from which script is being run does not have a configuration file
			echo -ne " but there is NO configuration file .QVRUQUNLIEZMQUc in $PWD"
			echo -ne "\nExiting..."
			return 1
		fi
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
if [[ -z $iface ]]; then
	echo -ne "but there is no detected VPN interface!\nExiting..."
	return 1
else
	if [[ $iface == $vpniface ]]; then
		echo -ne " found $iface.\n"
		vpnlocalipv4=$(ip addr show $vpniface | grep -w inet | awk '{print $2}' | cut -d "/" -f 1)
	else
		echo "VPN interface variable vpniface is set to $vpniface but detected interface is $iface."
		echo "Exiting..."
		return 1
	fi
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

# Log configuration
echo -ne "Touching configuration $CONFIGFILE . . ."
touch $CONFIGFILE
echo -ne " done. Copying environment variables into configuration . . ."
echo -ne "DATE\t$DTG\n" > $CONFIGFILE && echo -ne "NAME\t$targethostname\n" >> $CONFIGFILE && echo -ne "TARGET\t$TARGET\n" >> $CONFIGFILE && echo -ne "LHOST\t$LHOST\n" >> $CONFIGFILE
echo -ne " done.\n\nHappy hacking!\n"
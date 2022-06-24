#!/usr/bin/env bash

# Adapted from https://superuser.com/a/224263

# OpenSSL requires the port number.
SERVER=$1
DELAY=1
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')
pt3cipherarray=()
pt2cipherarray=()

echo Obtaining cipher list from $(openssl version).

for cipher in ${ciphers[@]}; do
    detail=$(openssl ciphers -v 'ALL:eNULL' | grep -P "(^|\s)\K${cipher}(?=\s|$)")
	protover=$(echo $detail | awk '{print $2}')
#	echo $cipher
#	echo $protover
	if [[ $protover == "TLSv1.3" ]]; then
		#pt3cipherarray+=$cipher
		pt3cipherarray=(${pt3cipherarray[@]} $cipher)
	elif [[ $protover == "TLSv1.2" ]]; then
		#pt2cipherarray+=$cipher
		pt2cipherarray=(${pt2cipherarray[@]} $cipher)
	fi
done

echo "Testing ${#pt3cipherarray[@]} TLSv1.3 Ciphers:"
for cipher in "${pt3cipherarray[@]}"; do
	echo -n Testing $cipher...
	test=$(echo -n | openssl s_client -ciphersuites "$cipher" -connect $SERVER 2>&1)
    if [[ "$test" =~ ":error:" ]] ; then
		error=$(echo -n $test | cut -d':' -f6)
		echo NO \($error\)
	elif [[ "$test" =~ "Cipher is ${cipher}" || "$test" =~ "Cipher    :" ]] ; then
		echo YES
	else
		echo UNKNOWN RESPONSE
		echo $test
	fi
	sleep $DELAY
	#echo $cipher
done

echo
echo "Testing ${#pt2cipherarray[@]} TLSv1.2 Ciphers"
for cipher in "${pt2cipherarray[@]}"; do
	echo -n Testing $cipher...
	test=$(echo -n | openssl s_client -cipher "$cipher" -connect $SERVER 2>&1)
	if [[ "$test" =~ ":error:" ]] ; then
		error=$(echo -n $test | cut -d':' -f6)
		echo NO \($error\)
	elif [[ "$test" =~ "Cipher is ${cipher}" || "$test" =~ "Cipher    :" ]] ; then
		echo YES
	else
		echo UNKNOWN RESPONSE
		echo $test
	fi
	sleep $DELAY

	#echo $cipher
done

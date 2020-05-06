#!/bin/sh
sed -i "/^pulse-access:x:[[:digit:]]*:pulse$/ s/$/,root/" /etc/group 2&> /dev/null 
while true; do
	tvservice_value=`tvservice -n | grep -c HDMI`
	bluetooth_status=`bluetoothctl info | grep -c "Connected"`

	if [[ $bluetooth_status -ne 0 ]]
	then
		echo "Bluetooth is connected"
		bluetooth_daemon=1

	elif [[ $tvservice_value -ne 0 ]]
	then
	
		# HDMI is the output 
		amixer cset numid=3 2 
		bluetooth_daemon=0
	else
		# wired speaker is the output 
		amixer cset numid=3 1	
	fi
done

	#kill -9 `ps x | grep bluetoothd | head -1 | cut -d " " -f 2`

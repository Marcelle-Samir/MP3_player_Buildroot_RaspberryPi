#!/bin/sh

touch /myApplications/nousb.txt 
touch /myApplications/withusb.txt
#touch /myApplications/USBData.txt

chmod 777 /myApplications/nousb.txt 
chmod 777 /myApplications/withusb.txt

chmod 777 /myApplications/songsList.txt

no_of_songs_system=$(sudo find / -name "*.mp3" | wc -l)

espeak -g15 -s130 -ven-us+f1 "You have $no_of_songs_system mp3 songs on SD Card of Raspberry pi" 2>/dev/null

fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $1}' > /myApplications/nousb.txt
fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $1}' > /myApplications/withusb.txt

while true; do
	diff /myApplications/nousb.txt /myApplications/withusb.txt > /dev/null
	while [ $? -eq 0 ]; do
    		sleep 3
   		fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $1}' > /myApplications/withusb.txt
		
		partitions=$(fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $1}')

		for partition in $partitions; do
			mountpoint="/media/$(basename $partition)"
			mkdir -p $mountpoint
			mount $partition $mountpoint
		done

		find $mountpoint -name "*.mp3" | wc -l > /myApplications/usb_songs_num.txt

		find /myApplications/Songs_list_source -name "*.mp3" > /myApplications/songsList.txt
		find $mountpoint -name "*.mp3" >> /myApplications/songsList.txt

		diff nousb.txt withusb.txt > /dev/null
	done
	fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $1}' > /myApplications/nousb.txt
done

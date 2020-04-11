#!/bin/sh

touch /myApplications/nousb.txt 
touch /myApplications/withusb.txt
touch /myApplications/no_of_songs_system.txt

chmod 777 /myApplications/nousb.txt 
chmod 777 /myApplications/withusb.txt
chmod 777 /myApplications/no_of_songs_system.txt
chmod 777 /myApplications/songsList.txt

no_of_songs_system=$(find / -name "*.mp3" | wc -l)
echo $no_of_songs_system > /myApplications/no_of_songs_system.txt

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
			espeak -g15 -s130 -ven-us+f1 "new storage device is added" --stdout | aplay
		done

		find $mountpoint -name "*.mp3" | wc -l > /myApplications/usb_songs_num.txt

		find /myApplications/Songs_list_source -name "*.mp3" > /myApplications/songsList.txt
		find $mountpoint -name "*.mp3" >> /myApplications/songsList.txt

		diff nousb.txt withusb.txt > /dev/null
	done
	fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $1}' > /myApplications/nousb.txt
	if [[ partitions -eq 0 ]]
	then
		espeak -g15 -s130 -ven-us+f1 "new storage device is removed" --stdout | aplay
	fi
done

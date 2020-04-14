#!/bin/sh

chmod 777 /myApplications/songsList.txt

while true; do

	ls /dev > /myApplications/dev_test.txt
	dev_grep=`grep -c "sdb1" /myApplications/dev_test.txt`
	if [[ $dev_grep -eq 0 ]]
	then
		 dev_grep=`grep -c "sda1" /myApplications/dev_test.txt`
	fi

	df > /myApplications/df_test.txt
	df_grep=`grep -c "sdb1" /myApplications/df_test.txt`

	if [[ $df_grep -eq 0 ]]
	then
		 df_grep=`grep -c "sda1" /myApplications/df_test.txt`
	fi


	if [[ $df_grep -eq 0  && $dev_grep -ne 0 ]]
	then
    		sleep 3
		partitions=$(fdisk -l /dev/sd* | grep -v 'Unknown' | grep -v 'Empty' | awk '/^\/dev\/sd/ {print $1}')
		
		for partition in $partitions; do
			mountpoint="/media/$(basename $partition)"
			mkdir -p $mountpoint
			mount $partition $mountpoint

			espeak -g15 -s130 -ven-us+f1 "storage device is added" --stdout | aplay
		done
		find $mountpoint -name "*.mp3" | wc -l > /myApplications/usb_songs_num.txt

		find /myApplications/Songs_list_source -name "*.mp3" > /myApplications/songsList.txt
		find $mountpoint -name "*.mp3" >> /myApplications/songsList.txt

	elif [[ $df_grep -ne 0  && $dev_grep -eq 0 ]]
	then
		espeak -g15 -s130 -ven-us+f1 "storage device is removed" --stdout | aplay
		umount $mountpoint
	fi
done

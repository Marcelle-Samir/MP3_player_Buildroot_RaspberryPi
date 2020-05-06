#!/bin/sh

chmod 777 /myApplications/song_status.txt

while true; do
	cat /myApplications/song_status.txt
	sleep 5
done

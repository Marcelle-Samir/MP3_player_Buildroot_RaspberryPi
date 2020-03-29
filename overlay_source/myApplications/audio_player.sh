#!/bin/sh

modprobe snd-bcm2835 

echo "26" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio26/direction

echo "16" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio16/direction

echo "5" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio5/direction

echo "6" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio6/direction

song_count=1

pause_play_flag=0

next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`

total_songs_num=`wc -l /myApplications/songsList.txt |  grep -oP "\d"`

while :
do
	if [[ $(cat /sys/class/gpio/gpio26/value) -eq 1 ]]
	then
		killall -15 mpv

		song_count=1
		next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`
		mpv /myApplications/$next_song &	
		pause_play_flag=0	

		echo "startsong= $next_song" >> /myApplications/debug.txt
		echo "startcount= $song_count" >> /myApplications/debug.txt

		sleep 0.25	
	fi


	if [[ $(cat /sys/class/gpio/gpio5/value) -eq 1 ]]
	then
		killall -15 mpv

		if [[ $song_count -lt $total_songs_num ]]
		then
			song_count=$(($song_count+1))
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`
			mpv /myApplications/$next_song &

		else
			song_count=1
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`
			mpv /myApplications/$next_song &	

		fi		

		pause_play_flag=0

		echo "nextsong= $next_song" >> /myApplications/debug.txt
		echo "nextcount= $song_count" >> /myApplications/debug.txt	

		sleep 0.25
	fi



	if [[ $(cat /sys/class/gpio/gpio6/value) -eq 1 ]]
	then
		killall -15 mpv

		if [[ $song_count -gt 1 ]]
		then
			song_count=$(($song_count-1))
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`
			mpv /myApplications/$next_song &

		else
			song_count=$total_songs_num
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`
			mpv /myApplications/$next_song &		
		
		fi	
		
		pause_play_flag=0

		echo "prevsong= $next_song" >> /myApplications/debug.txt
		echo "prevcount= $song_count" >> /myApplications/debug.txt

		sleep 0.25
	fi



	if [[ $(cat /sys/class/gpio/gpio16/value) -eq 1 ]]
	then
		if [[ $pause_play_flag -eq 0 ]]
		then		
			killall -20 mpv
			pause_play_flag=1
0
			echo "song paused" >> /myApplications/debug.txt

		elif [[ $pause_play_flag -eq 1 ]]		
		then		
			bg
			pause_play_flag=0

			echo "song replayed" >> /myApplications/debug.txt		
		fi
		
		sleep 0.25
	fi
done

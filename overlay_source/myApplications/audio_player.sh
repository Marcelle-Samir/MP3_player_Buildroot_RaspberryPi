#!/bin/sh
# add modules 
modprobe snd-bcm2835 
modprobe snd-seq-midi
modprobe snd-usb-audio

# set the buttons pin as input pins
##################################################
# Start button
echo "26" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio26/direction
# pause / play button
echo "16" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio16/direction
# next song button
echo "5" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio5/direction
# previous song button
echo "6" >> /sys/class/gpio/export
echo "in" >> /sys/class/gpio/gpio6/direction
##################################################

# echo the songs names exist in the Songs_list_source directory to form the songs_list  
find /myApplications/Songs_list_source -name "*.mp3" > /myApplications/songsList.txt

chmod 777 /myApplications/songsList.txt

echo "0" > /myApplications/play_pause_button.txt
echo "0" > /myApplications/next_button.txt
echo "0" > /myApplications/prev_button.txt
echo "0" > /myApplications/shuffle_button.txt

chmod 777 /myApplications/play_pause_button.txt
chmod 777 /myApplications/next_button.txt
chmod 777 /myApplications/prev_button.txt
chmod 777 /myApplications/shuffle_button.txt

# set an initial value to pause_play_flag so if the 
pause_play_flag=2
# get the total nsumber of songs exist in the songsList.txt  
total_songs_num=`cat /myApplications/songsList.txt | wc -l`
# set an initial value to song_cont
song_count=0

while :
do
	total_songs_num=`cat /myApplications/songsList.txt | wc -l`
	# getting the readings from the keyboard
	play_pause_button=`sed -n "1{p;q}" /myApplications/play_pause_button.txt`
	next_button=`sed -n "1{p;q}" /myApplications/next_button.txt`
	prev_button=`sed -n "1{p;q}" /myApplications/prev_button.txt`
	shuffle_button=`sed -n "1{p;q}" /myApplications/shuffle_button.txt`

	# play/pause button is pressed case 
	if [[ $(cat /sys/class/gpio/gpio26/value) -eq 1 ]]
	then
		if [[ $pause_play_flag -eq 0 ]]
		then		
			# stop the running song  
			killall -STOP mpv
			# set the pause_play_flag, because now there's a stopped song 
			pause_play_flag=1
			# this only for debugging 
			echo "song paused" >> /myApplications/debug.txt
		elif [[ $pause_play_flag -eq 1 ]]		
		then	
			# return the stoped song to the background	
			killall -CONT mpv
			# clear the pause_play_flag, because the isn't stopped songs anymore
			pause_play_flag=0
			# this only for debugging 
			echo "song replayed" >> /myApplications/debug.txt		
		
		elif [[ $pause_play_flag -eq 2 ]]		
		then
			# end any running process 
			killall -15 mpv
			# set the song_count to the initial value to play the first song in the songsList.txt
			song_count=1
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`
			# run the song in the background
			mpv $next_song &	
			# make sure that the pause_play_flag is cleared
			pause_play_flag=0
			# this only for debugging
			echo "startsong= $next_song" >> /myApplications/debug.txt
			echo "startcount= $song_count" >> /myApplications/debug.txt
		fi
		# to avoid button debouncing 
		sleep 0.5	

	elif [[ "$play_pause_button" -eq 1 ]]
	then
		if [[ $pause_play_flag -eq 0 ]]
		then		
			# stop the running song  
			killall -STOP mpv
			# set the pause_play_flag, because now there's a stopped song 
			pause_play_flag=1
			# this only for debugging 
			echo "song paused" >> /myApplications/debug.txt
		elif [[ $pause_play_flag -eq 1 ]]		
		then	
			# return the stoped song to the background	
			killall -CONT mpv
			# clear the pause_play_flag, because the isn't stopped songs anymore
			pause_play_flag=0
			# this only for debugging 
			echo "song replayed" >> /myApplications/debug.txt		
		
		elif [[ $pause_play_flag -eq 2 ]]		
		then
			# end any running process 
			killall -15 mpv
			# set the song_count to the initial value to play the first song in the songsList.txt
			song_count=1
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`
			# run the song in the background
			mpv $next_song &	
			# make sure that the pause_play_flag is cleared
			pause_play_flag=0
			# this only for debugging
			echo "startsong= $next_song" >> /myApplications/debug.txt
			echo "startcount= $song_count" >> /myApplications/debug.txt
		fi
		echo "0" > /myApplications/play_pause_button.txt
		# to avoid button debouncing 
		sleep 0.5	
	fi

	# next song button is pressed
	if [[ $(cat /sys/class/gpio/gpio5/value) -eq 1 ]]
	then
		# end any running process 
		killall -15 mpv
		if [[ $song_count -lt $total_songs_num ]]
		then
			# incrementing the song_count to select the next song in songsList.txt
			song_count=$((song_count+1))
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`	
			# this only for debugging 
			echo "nextsongIf= $next_song" >> /myApplications/debug.txt
			echo "nextcountIf= $song_count" >> /myApplications/debug.txt	
		else
			# reset the song_count to start the list from the first song  
			song_count=1
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`	
			# this only for debugging 
			echo "nextsongElse= $next_song" >> /myApplications/debug.txt
			echo "nextcountElse= $song_count" >> /myApplications/debug.txt	
		fi		
		# run the song in the background
		mpv $next_song &
		# make sure that the pause_play_flag is cleared
		pause_play_flag=0
		# to avoid button debouncing 
		sleep 0.5

	elif [[ "$next_button" -eq 1 ]]
	then
		# end any running process 
		killall -15 mpv
		if [[ $song_count -lt $total_songs_num ]]
		then
			# incrementing the song_count to select the next song in songsList.txt
			song_count=$((song_count+1))
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`	
			# this only for debugging 
			echo "nextsongIf= $next_song" >> /myApplications/debug.txt
			echo "nextcountIf= $song_count" >> /myApplications/debug.txt	
		else
			# reset the song_count to start the list from the first song  
			song_count=1
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`	
			# this only for debugging 
			echo "nextsongElse= $next_song" >> /myApplications/debug.txt
			echo "nextcountElse= $song_count" >> /myApplications/debug.txt	
		fi		
		# run the song in the background
		mpv $next_song &
		# make sure that the pause_play_flag is cleared
		pause_play_flag=0
		echo "0" > /myApplications/next_button.txt
		# to avoid button debouncing 
		sleep 0.5
	fi

	# previous song button is pressed
	if [[ $(cat /sys/class/gpio/gpio6/value) -eq 1 ]]
	then
		# end any running process 
		killall -15 mpv
		if [[ $song_count -gt 1 ]]
		then
			# decrementing the song_count to select the next song in songsList.txt
			song_count=$((song_count-1))
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`			
			# this only for debugging 
			echo "prevsongIf= $next_song" >> /myApplications/debug.txt
			echo "prevcountIf= $song_count" >> /myApplications/debug.txt
		else
			# reset the song_count to start the list from the last song  
			song_count=$total_songs_num
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`			
			# this only for debugging 
			echo "prevsongElse= $next_song" >> /myApplications/debug.txt
			echo "prevcountElse= $song_count" >> /myApplications/debug.txt
		fi	
		# run the song in the background
		mpv $next_song &
		# make sure that the pause_play_flag is cleared
		pause_play_flag=0
		# this only for debugging 
		echo "prevsong= $next_song" >> /myApplications/debug.txt
		echo "prevcount= $song_count" >> /myApplications/debug.txt
		# to avoid button debouncing 
		sleep 0.5

	elif [[ "$prev_button" -eq 1 ]]
	then
		# end any running process 
		killall -15 mpv
		if [[ $song_count -gt 1 ]]
		then
			# decrementing the song_count to select the next song in songsList.txt
			song_count=$((song_count-1))
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`			
			# this only for debugging 
			echo "prevsongIf= $next_song" >> /myApplications/debug.txt
			echo "prevcountIf= $song_count" >> /myApplications/debug.txt
		else
			# reset the song_count to start the list from the last song  
			song_count=$total_songs_num
			# pick the song name from the list to be played according to the song_count value
			next_song=`sed -n "$song_count{p;q}" /myApplications/songsList.txt`			
			# this only for debugging 
			echo "prevsongElse= $next_song" >> /myApplications/debug.txt
			echo "prevcountElse= $song_count" >> /myApplications/debug.txt
		fi	
		# run the song in the background
		mpv $next_song &
		# make sure that the pause_play_flag is cleared
		pause_play_flag=0
		# this only for debugging 
		echo "prevsong= $next_song" >> /myApplications/debug.txt
		echo "prevcount= $song_count" >> /myApplications/debug.txt
		echo "0" > /myApplications/prev_button.txt
		# to avoid button debouncing 
		sleep 0.5
	fi

	# shuffle button is pressed
	if [[ $(cat /sys/class/gpio/gpio16/value) -eq 1 ]]
	then
		temp_count=0
		while [[ $temp_count -lt $total_songs_num ]]
		do
		temp_count=$((temp_count+1))
		temp_song=`sed -n "$temp_count{p;q}" /myApplications/songsList.txt`
		songs_arr="$songs_arr $temp_song"
		done
		# end any running process 
		killall -15 mpv
		mpv --shuffle $songs_arr &	
		# make sure that the pause_play_flag is cleared
		pause_play_flag=0
		# this only for debugging
		echo "startsong= $next_song" >> /myApplications/debug.txt
		echo "startcount= $song_count" >> /myApplications/debug.txt
		shuffle_button=0
		# to avoid button debouncing 
		sleep 0.5
	elif [[ "$shuffle_button" -eq 1 ]]
	then
		temp_count=0
		while [[ $temp_count -lt $total_songs_num ]]
		do
		temp_count=$((temp_count+1))
		temp_song=`sed -n "$temp_count{p;q}" /myApplications/songsList.txt`
		songs_arr="$songs_arr $temp_song"
		done
		# end any running process 
		killall -15 mpv
		mpv --shuffle $songs_arr &	
		# make sure that the pause_play_flag is cleared
		pause_play_flag=0
		# this only for debugging
		echo "startsong= $next_song" >> /myApplications/debug.txt
		echo "startcount= $song_count" >> /myApplications/debug.txt
		shuffle_button=0
		# to avoid button debouncing 
		sleep 0.5
		echo "0" > /myApplications/shuffle_button.txt
	fi
done

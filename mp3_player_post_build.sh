#!/bin/sh

echo 'PS1="MP3_Shell>"' >> ${TARGET_DIR}/etc/profile

echo "dtparam=audio=on" >> /home/marcelle/new_buildroot/buildroot-2019.11.1/output/images/rpi-firmware/config.txt

echo 'CONFIG_SHUF=y' >> /home/marcelle/new_buildroot/buildroot-2019.11.1/package/busybox/busybox.config

echo 'echo Running at boot' >> ${TARGET_DIR}/etc/profile

#echo '/myApplications/startBluetooth.sh &' >> ${TARGET_DIR}/etc/profile

echo 'alias play="echo "1" > /myApplications/play_pause_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'alias pause="echo "1" > /myApplications/play_pause_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'alias next="echo "1" > /myApplications/next_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'alias previous="echo "1" > /myApplications/prev_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'alias shuffle="echo "1" > /myApplications/shuffle_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'echo "new Alias done"'

export PATH=/home/marcelle/new_buildroot/buildroot-2019.11.1/output/host/bin:$PATH
aarch64-linux-gcc ${TARGET_DIR}/myApplications/myapp.c -o ${TARGET_DIR}/myApplications/printHello.o







#!/bin/sh

echo 'PS1="MP3_Shell>"' >> ${TARGET_DIR}/etc/profile

echo 'dtparam=audio=on' >> /home/marcelle/new_buildroot/buildroot-2019.11.1/output/images/rpi-firmware/config.txt
echo 'enable_uart=1' >> /home/marcelle/new_buildroot/buildroot-2019.11.1/output/images/rpi-firmware/config.txt
#echo 'hdmi_safe=1' >> /home/marcelle/new_buildroot/buildroot-2019.11.1/output/images/rpi-firmware/config.txt
echo 'hdmi_drive=2' >> /home/marcelle/new_buildroot/buildroot-2019.11.1/output/images/rpi-firmware/config.txt


echo 'CONFIG_SHUF=y' >> /home/marcelle/new_buildroot/buildroot-2019.11.1/package/busybox/busybox.config

echo 'alias Play="echo "1" > /myApplications/play_pause_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'alias pause="echo "1" > /myApplications/play_pause_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'alias next="echo "1" > /myApplications/next_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'alias previous="echo "1" > /myApplications/prev_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'alias shuffle="echo "1" > /myApplications/shuffle_button.txt"' >> ${TARGET_DIR}/etc/profile
echo 'alias connect="/myApplications/connect_bluetooth.sh"' >> ${TARGET_DIR}/etc/profile

echo 'echo "Welcome to BuildRoot MP3 Player"' >> ${TARGET_DIR}/etc/profile
echo '/myApplications/display.sh &' >> ${TARGET_DIR}/etc/profile
export PATH=/home/marcelle/new_buildroot/buildroot-2019.11.1/output/host/bin:$PATH
#aarch64-linux-gcc ${TARGET_DIR}/myApplications/myapp.c -o ${TARGET_DIR}/myApplications/printHello.o







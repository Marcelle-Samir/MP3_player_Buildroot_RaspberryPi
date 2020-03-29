#!/bin/sh

echo 'PS1="MP3_Shell>"' >> ${TARGET_DIR}/etc/profile


echo "dtparam=audio=on" >> /home/marcelle/build_root/buildroot-2019.11.1/output/images/rpi-firmware/config.txt

echo 'CONFIG_SHUF=y' >> /home/marcelle/build_root/buildroot-2019.11.1/package/busybox/busybox.config

echo 'echo Running at boot' >> ${TARGET_DIR}/etc/profile
echo '/myApplications/audio_player.sh &' >> ${TARGET_DIR}/etc/profile

export PATH=/home/marcelle/build_root/buildroot-2019.11.1/output/host/bin:$PATH
aarch64-linux-gcc ${TARGET_DIR}/myApplications/myapp.c -o ${TARGET_DIR}/myApplications/printHello.o

#!/bin/sh
sudo modprobe hci_uart
sleep 2
lsmod
hciattach /dev/ttyAMA0 bcm43xx 921600 noflow -
sleep 2
/usr/libexec/bluetooth/bluetoothd &
sleep 2
hciconfig hci0 up
sleep 2
#export LIBASOUND_THREAD_SAFE=0
#sudo /usr/bin/bluealsa -S &
#bt-device -c 1C:A0:D3:9A:00:36 #soundBuds
#sudo bt-device -c 74:E5:43:F4:C5:F4 #jabra

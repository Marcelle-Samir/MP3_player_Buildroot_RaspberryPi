#!/bin/sh
modprobe hci_uart
sleep 2
lsmod
hciattach /dev/ttyAMA0 bcm43xx 921600 noflow -
sleep 2
/usr/libexec/bluetooth/bluetoothd &
sleep 2
hciconfig hci0 up
sleep 2
bluetoothctl pair 01:01:01:01:07:99
bluetoothctl connect 01:01:01:01:07:99
bluetoothctl trust 01:01:01:01:07:99
quit

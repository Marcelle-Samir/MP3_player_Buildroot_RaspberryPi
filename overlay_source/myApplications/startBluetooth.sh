#!/bin/sh
modprobe hci_uart
sleep 5
hciattach /dev/ttyAMA0 bcm43xx 921600 noflow -
sleep 5
/usr/libexec/bluetooth/bluetoothd &
sleep 5
hciconfig hci0 up
sleep 5


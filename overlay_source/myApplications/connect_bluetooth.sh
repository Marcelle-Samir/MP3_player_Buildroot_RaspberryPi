#!/bin/sh
bluetoothctl scan on &
sleep 20
bluetoothctl scan off
sleep 5
bluetoothctl connect 00:58:56:07:BA:E7
sleep 5
bluetoothctl trust 00:58:56:07:BA:E7
sleep 5

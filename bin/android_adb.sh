#!/bin/bash
IP=$1

if [ "$IP" = "" ];then
	echo "target ip address!!"
	exit 
fi
adb start-server
adb connect $IP
adb devices
adb shell

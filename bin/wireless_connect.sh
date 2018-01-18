#!/bin/bash
sudo killall wpa_supplicant
ip link show wlp2s0
wpa_passphrase 'Tab s' 0423326789 > wpa_connect.conf
sudo wpa_supplicant -B -D nl80211 -i wlp2s0 -c wpa_connect.conf
iw wlp2s0 link
sudo dhclient wlp2s0


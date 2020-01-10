#!/bin/bash
sudo route del -net 0.0.0.0 netmask 0.0.0.0 dev enp0s31f6
sudo route add -net 172.16.0.0 netmask 255.255.0.0 gw 192.168.10.1 dev enp0s31f6
route -n
sudo chmod 777 /etc/resolvconf/resolv.conf.d/head
sudo echo "nameserver 172.16.64.81" > /etc/resolvconf/resolv.conf.d/head
sudo echo "nameserver 172.16.64.82" >> /etc/resolvconf/resolv.conf.d/head
sudo echo "search mstarsemi.com.tw" >> /etc/resolvconf/resolv.conf.d/head
sudo echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head
sudo echo "nameserver 192.168.10.1" >> /etc/resolvconf/resolv.conf.d/head

sudo resolvconf -u

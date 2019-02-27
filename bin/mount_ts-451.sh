#!/bin/bash
sudo mount -t cifs -o username="admin",password="2jgiogdl",uid=1000,dir_mode=0777 //192.168.1.151/home /home/mark/ts-451
sudo mount -t cifs -o username="admin",password="2jgiogdl",uid=1000,dir_mode=0777 //192.168.1.151/USBDisk1 /home/mark/ts-451_USBDisk1


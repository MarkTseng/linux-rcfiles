#!/bin/bash

mount_ts451() {
    sudo mount -t cifs -o username="admin",password="2jgiogdl",uid=1000,dir_mode=0777 //192.168.1.151/home /home/mark/ts-451
    sudo mount -t cifs -o username="admin",password="2jgiogdl",uid=1000,dir_mode=0777 //192.168.1.151/USBDisk1 /home/mark/ts-451_USBDisk1
    sudo mount -t cifs -o username="mark",password="2jgiogdl",uid=1000,dir_mode=0777 //192.168.1.20/mark /home/mark/8TB
}
umount_ts451() {
    sudo umount /home/mark/ts-451_USBDisk1
    sudo umount /home/mark/ts-451
    sudo umount /home/mark/8TB
}
case "$1" in
    start)
    mount_ts451
    ;;

    stop)
    umount_ts451
    ;;

    *)
    echo "Usage: /etc/init.d/mount_ts451.sh {start|stop}" >&2
    exit 1
    ;;
esac

exit 0


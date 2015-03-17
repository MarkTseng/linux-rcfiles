#!/bin/bash
make clean; make -j 8
make modules_install INSTALL_MOD_PATH=rootfs
make 
cp vmlinux.bin  ~/tftp
#cp vmlinux  ~/tftp


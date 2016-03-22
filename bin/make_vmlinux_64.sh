#!/bin/bash
make ARCH=arm64 -j 8
make ARCH=arm64 modules_install INSTALL_MOD_PATH=rootfs
make ARCH=arm64
cp vmlinux.bin  ~/tftp
#cp vmlinux  ~/tftp


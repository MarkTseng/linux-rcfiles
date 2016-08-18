#!/bin/bash
#make -j 8
#make modules_install INSTALL_MOD_PATH=rootfs
#make 
#cp vmlinux.bin  ~/tftp
#cp vmlinux  ~/tftp
make -j4
cp -a arch/arm/boot/Image ../../release/SDK/arm/kernel/I1/LX318/arch/arm/boot/Image
cp -a modules/*.ko ../../release/SDK/arm/kernel/I1/LX318/modules
pushd ../../project/I1
make clean
make
popd
sync

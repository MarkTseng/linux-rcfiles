#!/bin/bash
#make oldconfig
#make clean
make -j4
# vmlinux.develop.avhdd.nike.scpu.nand.nxx.bin
# vmlinux.develop.avhdd.nike.scpu.nand.nxx.bin.zip
cp vmlinux.bin vmlinux.develop.avhdd.nike.scpu.nand.nxx.bin
rm vmlinux.develop.avhdd.nike.scpu.nand.nxx.bin.zip
zip -9 -j vmlinux.develop.avhdd.nike.scpu.nand.nxx.bin.zip vmlinux.develop.avhdd.nike.scpu.nand.nxx.bin
cp vmlinux /home/mark/RTK_workshop/nike/DTH_2CPU/develop/image_file_avhdd/components/packages/package6/vmlinux.develop.avhdd.nike.scpu.nand.nxx
cp vmlinux.develop.avhdd.nike.scpu.nand.nxx.bin.zip /home/mark/RTK_workshop/nike/DTH_2CPU/develop/image_file_avhdd/components/packages/package6
cp System.map /home/mark/RTK_workshop/nike/DTH_2CPU/develop/image_file_avhdd/components/packages/package6

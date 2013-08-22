#!/bin/bash
#make oldconfig
#make clean
make -j4
cp vmlinux.bin vmlinux.develop.avhdd.nike.scpu.nand.bin
rm vmlinux.develop.avhdd.nike.scpu.nand.bin.zip
zip -9 -j vmlinux.develop.avhdd.nike.scpu.nand.bin.zip vmlinux.develop.avhdd.nike.scpu.nand.bin
cp vmlinux /home/mark/RTK_workshop/nike/git/nike_git/develop/image_file_avhdd/components/packages/package2/vmlinux.develop.avhdd.nike.scpu.nand
cp vmlinux.develop.avhdd.nike.scpu.nand.bin.zip /home/mark/RTK_workshop/nike/git/nike_git/develop/image_file_avhdd/components/packages/package2/
cp System.map /home/mark/RTK_workshop/nike/git/nike_git/develop/image_file_avhdd/components/packages/package2/

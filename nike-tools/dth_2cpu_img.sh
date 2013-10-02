#!/bin/bash
CUR_DIR=$PWD

TvServerClient_DIR=$CUR_DIR/TvServerClient
DtvStub_DIR=$CUR_DIR/DtvStub
KCPU_DIR=$CUR_DIR/nike_kcpu
SCPU_DIR=$CUR_DIR/nike_scpu
AVSOFTWARE_DIR=$CUR_DIR/software

KCPU_IMG=$KCPU_DIR/system/tmp/develop.avhdd.nike.kcpu.nand.nxx_img
SCPU_IMG=$SCPU_DIR/system/tmp/develop.avhdd.nike.scpu.nand.nxx_img

##### update kcpu vmlinux with DtvStub #####
cp $DtvStub_DIR/system/project/DtvStub/DtvStub $KCPU_DIR/system/rootfs/shell.develop.avhdd.nike.kcpu.nand/usr/local/bin
cd $KCPU_DIR/system
make PRJ=develop.avhdd.nike.kcpu.nand.nxx CLEAN_ALL=n

##### Build install.img #####
cd $CUR_DIR
## remove old images
rm develop/image_file_avhdd/components/packages/package6/System.map.develop.avhdd.nike.*
rm develop/image_file_avhdd/components/packages/package6/vmlinux.develop.avhdd.nike.*

## copy new images
cp nike_kcpu/system/tmp/develop.avhdd.nike.kcpu.nand.nxx_img/* develop/image_file_avhdd/components/packages/package6/
cp nike_scpu/system/tmp/develop.avhdd.nike.scpu.nand.nxx_img/* develop/image_file_avhdd/components/packages/package6/

# recover rootfs
#cp ../../root.nand.tvserver.tar.bz2 develop/image_file_avhdd/components/packages/package6/root.nand.tar.bz2 

# replace private rcS file
cd develop/image_file_avhdd/components/packages/package6/
mkdir tmp
tar xfj root.nand.tar.bz2 -C tmp
cp /home/mark/RTK_workshop/rcS_tvserver tmp/usr/local/etc/rcS
cd tmp/ ; tar cjvf ../root.nand.tar.bz2 *
cd ../
rm -rf tmp
cd $CUR_DIR

## copy audio firmware image to packages6
cp develop/image_file/components/Nxx/AV_FW/bluecore.audio.zip develop/image_file_avhdd/components/packages/package6/bluecore.audio.zip
cp develop/image_file/components/Nxx/AV_FW/System.map.audio develop/image_file_avhdd/components/packages/package6/System.map.audio
#cp software/audio/src/Integrated/project/dvr_audio/bluecore.audio.zip develop/image_file_avhdd/components/packages/package6/bluecore.audio.zip
#cp software/audio/src/Integrated/project/dvr_audio/bluecore.audio.text.zip develop/image_file_avhdd/components/packages/package6/bluecore.audio.text
#cp software/audio/src/Integrated/project/dvr_audio/System.map.audio develop/image_file_avhdd/components/packages/package6/System.map.audio

## copy video firmware image to packages6
cp develop/image_file/components/SQA_DailyBuild/AV_FW/bluecore.video.zip_support_kcpu develop/image_file_avhdd/components/packages/package6/bluecore.video.zip
cp develop/image_file/components/SQA_DailyBuild/AV_FW/video_firmware.text.zip_support_kcpu develop/image_file_avhdd/components/packages/package6/video_firmware.text
cp develop/image_file/components/SQA_DailyBuild/AV_FW/System.map.video_support_kcpu develop/image_file_avhdd/components/packages/package6/System.map.video

## copy Nxx AP
rm -rf develop/image_file_avhdd/components/packages/package6/AP/bin
cp -a $TvServerClient_DIR/system/project/TvServer_Nike_ABS_S/bin develop/image_file_avhdd/components/packages/package6/AP/

## install.img
cd develop/image_file_avhdd/
make image install_ap=1 PACKAGES=package6
mv install.img $CUR_DIR
#!/bin/bash
CUR_DIR=$PWD
## build source code
cd system/src
make clean
make 2>&1 | tee ../../system_log

if [ $? -ne 0 ]; then
	echo "build fail ; see system_log file"
	exit
fi

cd ../project/Realtek
make release 2>&1 | tee ../../../project_log

if [ $? -ne 0 ]; then
	echo "build fail ; see project_log file"
	exit
fi


## ready for install.img
cd ../../../
cd develop/image_file_avhdd/
cp ../image_file/components/SQA_DailyBuild/AV_FW/System.map.* components/packages/package2/
cp ../image_file/components/SQA_DailyBuild/AV_FW/bluecore.audio.zip components/packages/package2/
cp ../image_file/components/SQA_DailyBuild/AV_FW/bluecore.video.zip components/packages/package2/
rm -rf components/packages/package2/AP/bin
cp -a ../../system/project/Realtek/bin/ components/packages/package2/AP/
make image install_ap=1 install_bootloader=1 hash_imgfile=1 install_factory=1 factory_file=factory_GS.tar PACKAGES=package2
#make image install_ap=1 hash_imgfile=1 install_factory=1 factory_file=factory_SY.tar PACKAGES=package2
#make image install_ap=1 hash_imgfile=1 install_factory=1 factory_file=factory_GS.tar PACKAGES=package2
mv install.img $CUR_DIR



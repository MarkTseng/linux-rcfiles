#!/bin/bash
function help
{
	echo "CONFIG_100_6_01: CONFIG_100 + RTD6259-DEMO + DVB_C + BESTV" 
	echo "CONFIG_100_6_02: CONFIG_100 + RTD6259-DEMO + DTMB + BESTV "
}

function build_image
{
	LOGFILE=$1
	## build source code
	cd system/src
	make clean
	make 2>&1 | tee ../../$LOGFILE
	
	if [ $? -ne 0 ]; then
		echo "build fail ; see $LOGFILE file"
		exit
	fi

	cd ../project/Realtek
	make release 

	if [ $? -ne 0 ]; then
		echo "build fail ; see $LOGFILE file"
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
	make image install_ap=1 hash_imgfile=1 PACKAGES=package2
	mv install.img ../../.
	cd ../../
}

# global variable
MAKECONFIG="$PWD/system/include/MakeConfig"
DAILY_BUILD_DIR="daily_build"
DATETIME=`date +%F`
IMAGE_DIR_BASE="$DAILY_BUILD_DIR/$DATETIME"
IMG_LIST="CONFIG_100_6_01 CONFIG_100_6_02"
QUICK_CONFIG_STRING=`grep QUICK_CONFIG $MAKECONFIG | head -n 1 | cut -d'=' -f2`

# check dialy build dir
if [ ! -d $IMAGE_DIR_BASE ];then
	echo "mkdir $IMAGE_DIR_BASE"
	mkdir -p $IMAGE_DIR_BASE	
fi

# svn update
svn up

# restore MakeConfig
if [ $QUICK_CONFIG_STRING != " " ];then
	rm -rf $MAKECONFIG
	svn up $MAKECONFIG
fi

#replace QUICK_CONFIG to CONFIG_100
quick_config_str="0,/QUICK_CONFIG = /s/QUICK_CONFIG = /QUICK_CONFIG = CONFIG_100/"
sed -i "$quick_config_str" $MAKECONFIG

for img_name in $IMG_LIST
do
	#replace QUICK_SUB_CONFIG 
	replace_str="0,/QUICK_SUB_CONFIG = /s/QUICK_SUB_CONFIG = /QUICK_SUB_CONFIG = $img_name/"
	replace_str_orig="0,/QUICK_SUB_CONFIG = $img_name/s/QUICK_SUB_CONFIG = $img_name/QUICK_SUB_CONFIG = /"
	sed -i "$replace_str" $MAKECONFIG
	
	# mkdir 
	CONFIG_DIR="$IMAGE_DIR_BASE/$img_name"
	if [ ! -d $CONFIG_DIR ];then
		echo "mkdir $CONFIG_DIR"
		mkdir $CONFIG_DIR	
	fi

	# build image
	build_image "$CONFIG_DIR/log"

	mv install.img $CONFIG_DIR/install.img
	sed -i "$replace_str_orig" $MAKECONFIG
done

#replace QUICK_CONFIG to empty
quick_config_str="0,/QUICK_CONFIG = CONFIG_100/s/QUICK_CONFIG = CONFIG_100/QUICK_CONFIG = /"
sed -i "$quick_config_str" $MAKECONFIG

#show help
help

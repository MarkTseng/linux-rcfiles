#!/bin/bash
CUR_DIR=$PWD

TvServerClient_DIR=$CUR_DIR/TvServerClient
DtvStub_DIR=$CUR_DIR/DtvStub
KCPU_DIR=$CUR_DIR/nike_kcpu
SCPU_DIR=$CUR_DIR/nike_scpu
AVSOFTWARE_DIR=$CUR_DIR/software

KCPU_IMG=$KCPU_DIR/system/tmp/develop.avhdd.nike.kcpu.nand.nxx_img
SCPU_IMG=$SCPU_DIR/system/tmp/develop.avhdd.nike.scpu.nand.nxx_img

##### create directory #####
if [ ! -d $TvServerClient_DIR ]; then
	mkdir $TvServerClient_DIR
fi

if [ ! -d $DtvStub_DIR ]; then
	mkdir $DtvStub_DIR
fi

if [ ! -d $KCPU_DIR ]; then
	mkdir $KCPU_DIR
fi

if [ ! -d $SCPU_DIR ]; then
	mkdir $SCPU_DIR
fi

if [ ! -d $AVSOFTWARE_DIR ]; then
	mkdir $AVSOFTWARE_DIR
fi

##### checkout source code #####

# SCPU
cd $SCPU_DIR
svn co -r580586 http://cadinfo.realtek.com/svn/col/DVR/venus/software/system/OS/Linux/linux-2.6.34
svn co -r580239 http://cadinfo.realtek.com/svn/col/DVR/venus/software/system/OS/Linux/system
echo "SCPU SVN checkout done!"
read pause

# KCPU
cd $KCPU_DIR
svn co -r581014 http://cadinfo.realtek.com/svn/col/DVR/nike/software/system/OS/Linux/linux-2.6.34
svn co -r508079 http://cadinfo.realtek.com/svn/col/DVR/nike/software/system/OS/Linux/system
echo "KCPU SVN checkout done!"
read pause

# TvServerClient_DIR
cd $TvServerClient_DIR
svn co http://cadinfo.realtek.com/svn/col/DVR/nike/software/common common_nike
svn co -N http://cadinfo.realtek.com/svn/col/DVR/branches/software/system
cd system
svn up src lib lib_release include 
svn co -N http://cadinfo.realtek.com/svn/col/DVR/branches/software/system/project
cd project
svn up TvServer_Nike_ABS_S TvClient_Nike_ABS_S WatchDogApp DtvStub
echo "TvServerClient SVN checkout done!"
read pause

# DtvStub_DIR
cp -a $TvServerClient_DIR/* $DtvStub_DIR
echo "DtvStub SVN copy done!"
read pause

# audio / video common and software directory
cd $AVSOFTWARE_DIR
svn co http://cadinfo.realtek.com/svn/col/DVR/nike/software/common
cd $AVSOFTWARE_DIR
mkdir -p audio/src
cd audio/src
svn co http://cadinfo.realtek.com.tw/svn/col/DVR/nike/software/audio/branches/realtek/bringup/Integrated
cd $AVSOFTWARE_DIR
svn co http://cadinfo.realtek.com.tw/svn/col/DVR/nike/software/video
svn co http://cadinfo.realtek.com.tw/svn/col/DVR/nike/software/build
echo "AV software SVN checkout done!"
read pause

# develop for install.img
cd $CUR_DIR
svn co -r580370 http://cadinfo.realtek.com/svn/col/DVR/nike/software/system/flash_environment/develop
echo "source code checkout done!"

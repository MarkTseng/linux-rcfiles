#!/bin/bash
CUR_DIR=$PWD

TvServerClient_DIR=$CUR_DIR/TvServerClient
DtvStub_DIR=$CUR_DIR/DtvStub
KCPU_DIR=$CUR_DIR/nike_kcpu
SCPU_DIR=$CUR_DIR/nike_scpu
AVSOFTWARE_DIR=$CUR_DIR/software

KCPU_IMG=$KCPU_DIR/system/tmp/develop.avhdd.nike.kcpu.nand.nxx_img
SCPU_IMG=$SCPU_DIR/system/tmp/develop.avhdd.nike.scpu.nand.nxx_img

##### modify file kcpu rcS #####
if [  ! -e .kcpu_rcS_update ]; then
	echo "/sbin/ifconfig eth0 192.168.135.70 netmask 255.255.255.0" >> $KCPU_DIR/system/rootfs/shell.develop.avhdd.nike.kcpu.nand/etc/init.d/rcS
	echo "/sbin/route add default gw 192.168.135.1 dev eth0" >> $KCPU_DIR/system/rootfs/shell.develop.avhdd.nike.kcpu.nand/etc/init.d/rcS
	touch .kcpu_rcS_update
	echo "rcS update done!"
	read pause
fi


##### Compile DTH 2CPU #####
# SCPU 
if [  ! -e .scpu_compiled ]; then
	cd $SCPU_DIR/system
	make PRJ=develop.avhdd.nike.scpu.nand.nxx
	touch .scpu_compiled
	echo "SCPU compile done!"
	read pause
fi

# KCPU
if [  ! -e .kcpu_compiled ]; then
	cd $KCPU_DIR/system
	make PRJ=develop.avhdd.nike.kcpu.nand.nxx 
	touch .kcpu_compiled
	echo "KCPU compile done!"
	read pause
fi

# TvServerClient
cd $TvServerClient_DIR/system
if [  ! -e $CUR_DIR/.TvServerClient_MakeConfig_updated ]; then
	echo "check QUICK_CONFIG ENABLE_DTV_PROXY"
	vi include/MakeConfig
	touch $CUR_DIR/.TvServerClient_MakeConfig_updated
fi
cd src
make clean
make
cd $TvServerClient_DIR/system/project/TvServer_Nike_ABS_S
make release
cd $TvServerClient_DIR/system/project/TvClient_Nike_ABS_S
make release
echo "TvServerClient compile done"
read pause

# DtvStub
cd $DtvStub_DIR/system
if [  ! -e $CUR_DIR/.DtvStub_MakeConfig_updated ]; then
	echo "check QUICK_CONFIG ENABLE_DTV_STUB"
	vi include/MakeConfig
	touch $CUR_DIR/.DtvStub_MakeConfig_updated
fi
cd src
make clean
make
cd $DtvStub_DIR/system/project/DtvStub
make release
echo "DtvStub compile done!"
read pause

# AV FW compile
if [  ! -e $CUR_DIR/.avfw_compiled ]; then
	export PROJECT_HOME=$CUR_DIR
	export PATH=$PATH:/usr/local/ws_tool_chain/nike/rsdk-1.4.2/linux/newlib/bin
	if [ -f ${PROJECT_HOME}/software/regression/bashrc.regression ]; then
	  . ${PROJECT_HOME}/software/regression/bashrc.regression
	fi
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

	# audio fw
	cd $AVSOFTWARE_DIR
	cd audio/src/Integrated/src/
	cp MkCfgSQA/nike/MakeConfig_nike_support_kcpu MakeConfig
	make clean
	make
	ls -l ../project/dvr_audio
	echo "audio firmware compile done!"
	read pause

	# video fw
	cd $AVSOFTWARE_DIR
	cd build/video
	make clean
	make 
	echo "video firmware compile done!"
	touch $CUR_DIR/.avfw_compiled
	read pause

fi

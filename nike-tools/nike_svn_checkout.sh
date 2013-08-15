#!/bin/bash
DEFAULT_SVN_ROOT="nike_svn"
ROOT_DIR=$1

if [ -d $DEFAULT_SVN_ROOT ];then
	echo "$DEFAULT_SVN_ROOT exist"
	exit 1;
fi

mr -p checkout
mr -p update

if [ ! -n $ROOT_DIR ];then
	mv $DEFAULT_SVN_ROOT $ROOT_DIR
fi

# link toolchain
cd $DEFAULT_SVN_ROOT/system
ln -s ../../../toolchain toolchain


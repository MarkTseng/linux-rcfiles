#!/bin/bash
PATCH_NAME=$1
if [ "$PATCH_NAME" = "" ];then
	echo "give me a patch file name" 
	exit 0
fi

RVERSION=`svn info | grep Revision: | cut -d' ' -f2`
DIFF_FILES=`svn st | grep ^[MA] | cut -d' ' -f8`
svn di $DIFF_FILES > "$PATCH_NAME"_"$RVERSION".patch


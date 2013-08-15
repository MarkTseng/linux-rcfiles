#!/bin/sh
pids=`pidof DvdPlayer`
for pid in $pids    
do                                                                                                                  
	cat /proc/$pid/stat | awk '{print $1 $2 $18}'                                                                   
done                           

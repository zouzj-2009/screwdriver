#!/bin/bash
sdev=`getsd.sh $1|awk '{print $1}'`
[ -z "$sdev" ] && exit
tid=$1
l=$((tid&0xf))
s=$(((tid>>4)&0xf))
c=$(((tid>>8)&0x3))
h=$(((tid>>10)&0x7))
CONFIG=/proc/scsi_target/config
ISCSICFG=/proc/scsi_target/iscsi_target/params
DEVCFG=/proc/scsi_target/dev_disk_fileio/dev_disk_fileio
#is dev exist?
if [ -z "`cat $CONFIG|grep ^$tid`" ];then
	echo "target $tid not exist."
	exit 1
fi

#is already write through?
if [ -z "`cat $CONFIG|grep ^$tid|grep 'file'`" ];then
	echo "target $tid already in write through."
	exit 2
fi

#now change to write through
exec 2>/dev/null
echo "set disable -i $tid" >$CONFIG 2>/dev/null
echo "remove $tid" >$DEVCFG 2>/dev/null
echo "set enable -i $tid -t phy" >$CONFIG 2>/dev/null
echo "kick ref session -t $tid" >$ISCSICFG 2>/dev/null

#check weather ok
result=`cat $CONFIG|grep ^$tid|grep 'enable'|grep 'file'`
if [ ! -z "$result" ];then
	echo "something bad, changto write through fail!"
	exit 3
else
	echo "target $tid now in write through."
	logger "enable write through of target $tid"
	exit 0
fi

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
[ -z "$2" ] && defaultio=`cat /etc/userdata/sysconfig/defaultio 2>/dev/null` || defaultio=$2
[ -z "$defaultio" ] && defaultio=cfq
[ "$defaultio" = "sequence" ] && defaultio=anticipatory
[ "$defaultio" = "random" ] && defaultio=cfq
[ "$defaultio" != "cfq" -a "$defaultio" != "anticipatory" ] && defaultio=anticipatory
oldio=`cat /sys/block/$sdev/queue/scheduler |sed 's/.*\[\([a-z]*\)\].*/\1/g'`

#is dev exist?
if [ -z "`cat $CONFIG|grep ^$tid`" ];then
	echo "target $tid not exist."
	exit 1
fi

#is already write back?
if [ ! -z "`cat $CONFIG|grep ^$tid|grep 'file'`" ];then
	if [ "$defaultio" = "$oldio" ];then
		echo "target $tid already in write back ($defaultio)."
		exit 2
	else
		echo "target $tid already in write back ($oldio), change iotype to ($defaultio)."
		echo "$defaultio" >/sys/block/$sdev/queue/scheduler
		logger "change target $tid's write back iotype($oldio->$defaultio)"
		exit 0
	fi
fi

#now change to write back
exec 2>/dev/null
echo "set disable -i $tid" >$CONFIG 2>/dev/null
echo "kick ref session -t $tid" >$ISCSICFG 2>/dev/null
ln /dev/$sdev -s "/etc/diskfile/scst_disk_file_$h""_$c""_$s""_$l" -f
echo "create $tid" >$DEVCFG 2>/dev/null
echo "set enable -i $tid -t fileio" >$CONFIG 2>/dev/null
echo "$defaultio" >/sys/block/$sdev/queue/scheduler

#check weather ok
result=`cat $CONFIG|grep ^$tid|grep 'enable'|grep 'file'`
if [ -z "$result" ];then
	echo "something bad, changto write back fail!"
	exit 3
else
	echo "target $tid now in write back."
	logger "enable write back of target $tid ($defaultio)"
	exit 0
fi

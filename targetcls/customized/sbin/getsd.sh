#!/bin/bash
#set -x
tid=`echo $1|sed 's/[^0-9]//g'`
[ -z "$tid" ] && exit
for disk in `ls /sys/block|grep ^sd`
do
	h=`ls /sys/block/$disk/device/|grep "scsi_device:"|awk -F: '{print $2}'`
	c=`ls /sys/block/$disk/device/|grep "scsi_device:"|awk -F: '{print $3}'`
	s=`ls /sys/block/$disk/device/|grep "scsi_device:"|awk -F: '{print $4}'`
	l=`ls /sys/block/$disk/device/|grep "scsi_device:"|awk -F: '{print $5}'`
	sg=`ls /sys/block/$disk/device/|grep scsi_gen|awk -F: '{print $2}'`
	ttid=$((l+(s<<4)+(c<<8)+(h<<10)))
#if [ -z "`cat /proc/scsi_target/config|grep ^$ttid' '`" ];then  #if this not exist! check other
if [ -f /etc/userdata/sysconfig/scst_idmap ];then
	case "`cat /etc/userdata/sysconfig/scst_idmap`" in
0)
	ttid=$((l+(s<<4)+(c<<8)+(h<<10)))
	;;
1)
	ttid=$((l%256))
	;;
4)
	ttid=$((l%256))
	;;
2)
	ttid=$(((l%256)+(s<<8)))
	;;
3)
	ttid=$(((l%256)+(h<<8)))
	;;
*)
	ttid=$((l+(s<<4)+(c<<8)+(h<<10)))
	;;
	esac
else
	ttid=$((l+(s<<4)+(c<<8)+(h<<10)))
fi
#fi
	if [ "$ttid" = "$tid" ];then
		echo "$disk $h:$c:$s:$l $sg"
		exit
	fi
done


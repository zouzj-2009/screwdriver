#!/bin/bash
[ $# -ne 1 ] && exit 1
disk=$1
[ ! -d "/sys/block/$disk/device" ] && exit 2
h=`ls /sys/block/$disk/device/|grep "scsi_device:"|awk -F: '{print $2}'`
c=`ls /sys/block/$disk/device/|grep "scsi_device:"|awk -F: '{print $3}'`
s=`ls /sys/block/$disk/device/|grep "scsi_device:"|awk -F: '{print $4}'`
l=`ls /sys/block/$disk/device/|grep "scsi_device:"|awk -F: '{print $5}'`
sg=`ls /sys/block/$disk/device/|grep scsi_gen|awk -F: '{print $2}'`
if [ -f /etc/userdata/sysconfig/scst_idmap ];then
	case "`cat /etc/userdata/sysconfig/scst_idmap`" in
0)
	tid=$((l+(s<<4)+(c<<8)+(h<<10)))
	;;
1)
	tid=$((l%256))
	;;
4)
	tid=$((l%256))
	;;
2)
	tid=$(((l%256)+(s<<8)))
	;;
3)
	tid=$(((l%256)+(h<<8)))
	;;
*)
	tid=$((l+(s<<4)+(c<<8)+(h<<10)))
	;;
	esac
else
	tid=$((l+(s<<4)+(c<<8)+(h<<10)))
fi

#if [ -z "`cat /proc/scsi_target/config|grep ^$tid' '`" ];then  #if this not exist! check other
#	tid=$((l+(s<<4)+(c<<8)+(h<<10)))
#fi
echo "$disk $sg $h $c $s $l $tid"


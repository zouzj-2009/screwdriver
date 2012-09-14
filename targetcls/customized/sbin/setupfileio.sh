#!/bin/bash
[ ! -e /proc/scsi_target/config ] && exit
for tid in `cat /etc/userdata/sysconfig/iotype 2>/dev/null|grep ^wb|awk '{print $2}'`
do
	type=`cat /etc/userdata/sysconfig/iotype 2>/dev/null|grep "^wb $tid "|awk '{print $3}'`
	/sbin/diskwb.sh $tid $type
done

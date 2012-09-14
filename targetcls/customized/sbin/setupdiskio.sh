#!/bin/bash
[ ! -e /proc/scsi_target/config ] && exit
for tid in `cat /etc/userdata/sysconfig/iotype 2>/dev/null|grep ^wt|awk '{print $2}'`
do
	/sbin/diskwt.sh $tid
done

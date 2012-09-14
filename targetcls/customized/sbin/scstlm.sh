#!/bin/bash
if [ "$1" = "save" ];then
	cat /proc/scsi_target/lunmapping >/etc/userdata/sysconfig/scstlm.save 2>/dev/null
	exit
fi
if [ "$1" = "restore" ];then
	if [ ! -z "$2" ];then
		savefile=/etc/userdata/sysconfig/$2
	else
		savefile=/etc/userdata/sysconfig/scstlm.save
	fi
	cat $savefile 2>/dev/null|grep -v ^#|sed 's/ */ /g'| sed 's/^ */echo add /g'|sed 's/$/ >\/proc\/scsi_target\/lunmapping/g' >/tmp/.scstlm
	. /tmp/.scstlm
	exit
fi

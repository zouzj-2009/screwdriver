#!/bin/bash
host_setup()
{
	shell fc targetmode host${1} 0 #force initiator at first
	if [ "${2}" = "1" ];then
		echo "wait for fc host${1} ENABLE ..."
		sleep 12
		shell fc targetmode host${1} 1 
		#remove scsi-device from this host!
		cat /proc/scsi/scsi|grep "Host: scsi${1}"|sed 's/ 0/ /g'|awk '{print "echo scsi remove-single-device "'${1}'" "$4" "$6" "$8" >/proc/scsi/scsi"}' >/tmp/.fctgt
		[ -f /etc/userdata/sysconfig/fctgtonly ] && . /tmp/.fctgt
	fi
}

if [ "$1" = "setup" ];then
	hn=0
	for host in `ls /sys/class/fc_host/`
	do	
		host=`basename $host`
		hno=`echo $host|sed 's/host//g'`
		if [ -f /etc/userdata/sysconfig/fc_$host ];then
			mode=`cat /etc/userdata/sysconfig/fc_$host`
		else
			if [ "$hn" = "0" ];then
				mode=1 #target
			else	
				mode=0 #initiator
			fi
		fi
		host_setup $hno $mode
		let hn++
	done
	exit
fi


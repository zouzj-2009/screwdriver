#!/bin/bash
[ "$1" = "-f" ] && forceremove=1 || forceremove=0
[ -f /etc/userdata/sysconfig/keeprdacmember ] && forceremove=0 

[ -f /etc/userdata/sysconfig/enablerdacdisk ] && exit
[ ! -f /etc/userdata/sysconfig/rdac ] && exit
get_qutom_disk()
{
	#cat /etc/userdata/sysconfig/qutomdisk|awk '{print $1}'|sed 's/\/dev\///g'
	cd /www/cgi-bin
#	./sd2id.pl -a
	echo none
	cd -
}
scsi_disk_op()
{
	[ $forceremove -eq 0 ] && return
	qdisk=`get_qutom_disk`
	qsdisk=`cat /etc/userdata/sysconfig/qutomdisk 2>/dev/null|awk '{print $1}'|sed 's/\/dev\///g'`
	tdisk=`getsd.sh ${2}|awk '{print $1}'`
	if [ "$qdisk" = "$tdisk" ];then
		logger "RDAC skip qutom disk `getsd.sh ${2}`"
		return
	fi
	if [ "$qsdisk" = "$tdisk" ];then
		logger "RDAC skip saved qutom disk `getsd.sh ${2}`"
		return
	fi
	echo "echo scsi ${1}-single-device `getsd.sh ${2}|awk '{print $2}'|sed 's/:/ /g'` >/proc/scsi/scsi" >/tmp/rdac.scsiop
	logger "RDAC scsi $*"
	. /tmp/rdac.scsiop
}
for disk in `cat /proc/scsi_target/config 2>/dev/null|awk '{print $1}'`
do
	qdisk=`get_qutom_disk`
	qsdisk=`cat /etc/userdata/sysconfig/qutomdisk 2>/dev/null|awk '{print $1}'|sed 's/\/dev\///g'`
	tdisk=`getsd.sh $disk|awk '{print $1}'`
	if [ "$qdisk" = "$tdisk" ];then
		logger "RDAC skip qutom disk `getsd.sh $disk`"
		continue
	fi
	if [ "$qsdisk" = "$tdisk" ];then
		logger "RDAC skip saved qutom disk `getsd.sh $disk`"
		continue
	fi
	if [ "`getsd.sh $disk|wc -l`" -eq 0 ];then
		echo "disable RDAC member disk $disk."
		logger "disable RDAC member disk `getsd.sh $disk`."
		echo "set disable -i $disk" >/proc/scsi_target/config
		[ $forceremove -eq 1 ] && scsi_disk_op remove $disk
	else
		fdisk /dev/`getsd.sh $disk|awk '{print $1}'` 2>/dev/null >/dev/null<<EOF
q

EOF
		if [ $? -ne 0 ];then
			echo "disable MPIO member disk $disk."
			logger "disable MPIO member disk `getsd.sh $disk`."
			echo "set disable -i $disk" >/proc/scsi_target/config
			[ $forceremove -eq 1 ] && scsi_disk_op remove $disk
		fi
	fi
done

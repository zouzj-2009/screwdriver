#!/bin/bash
if [ -f /proc/scsi_target/iscsi_target/groups ];then
	group=on
else
	group=off
fi
if [ "$group" = "off" ];then #no group
cd /www/cgi-bin/
if [ "$1" = "-t" ];then
echo "initiator-name                                         initator-ip    target-id"
echo "-------------------------------------------------------------------------------" 
fi

if [ "$1" = "-p" ];then
./iscsiinfo.sh /proc/scsi_target/iscsi_target/0|awk '{printf "%-55s %-15s %-5s %s %s\n", $29, $8, $1, $13, $26}'|sort
else
./iscsiinfo.sh /proc/scsi_target/iscsi_target/0|awk '{printf "%-55s %-15s %s %s\n", $29, $8, $1, $26}'|sort
fi
cd -
else #group enable
cd /www/cgi-bin/
if [ "$1" = "-t" ];then
echo "initiator-name                           initator-ip     target_ip    target-id"
echo "-------------------------------------------------------------------------------" 
fi

if [ "$1" = "-p" ];then
./iscsiinfo.sh /proc/scsi_target/iscsi_target/0|awk '{printf "%-40s %-15s %-15s %-5s %s %s\n", $29, $8, $10, $1, $13, $26}'|sort
else
./iscsiinfo.sh /proc/scsi_target/iscsi_target/0|awk '{printf "%-40s %-15s %-15s %s %s\n", $29, $8, $10, $1, $26}'|sort
fi
cd -
fi

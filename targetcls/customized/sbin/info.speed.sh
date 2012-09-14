#!/bin/bash
if [ -f /proc/scsi_target/iscsi_target/groups ];then
	group=on
else
	group=off
fi
cat /proc/scsi_target/iscsi_target/0 >/tmp/info.speed
if [ "$group" = "off" ];then #no group
cd /www/cgi-bin/
if [ "$1" = "-t" ];then
echo "initiator-name                                         target-id  W mb/s R mb/s"
echo "-------------------------------------------------------------------------------" 
fi

if [ "$1" = "-p" ];then
./iscsiinfo.sh /tmp/info.speed|awk '{printf "%-55s %-5s %s %-5s %5.1f %5.1f\n", $29, $1, $13, $26, $21/1024/1024, $23/1024/1024}'|sort
else
./iscsiinfo.sh /tmp/info.speed|awk '{printf "%-55s %-5s %s %5.1f %5.1f \n", $29, $1, $26, $21/1024/1024, $23/1024/1024}'|sort
fi
cd -
else #group enable
cd /www/cgi-bin/
if [ "$1" = "-t" ];then
echo "initiator-name                            target_ip    target-id  W mb/s R mb/s"
echo "-------------------------------------------------------------------------------" 
fi

if [ "$1" = "-p" ];then
./iscsiinfo.sh /tmp/info.speed|awk '{printf "%-40s %-15s %-5s %s %-5s %5.1f %5.1f\n", $29, $10, $1, $13, $26, $21/1024/1024, $23/1024/1024}'|sort
else
./iscsiinfo.sh /tmp/info.speed|awk '{printf "%-40s %-15s %-5s %s %5.1f %5.1f\n", $29, $10, $1, $26, $21/1024/1024, $23/1024/1024}'|sort
fi
cd -
fi

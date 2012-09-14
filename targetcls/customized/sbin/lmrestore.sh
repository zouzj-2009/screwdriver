#!/bin/bash
if [ -f /proc/scsi_target/iscsi_target/groups -a -f /etc/userdata/sysconfig/ipgroups ];then
echo "Restoring IP Groups setting ..."
echo -------------------
cat /etc/userdata/sysconfig/ipgroups|sed 's/:\|(\|)/ /g'|/bin/grpres.sh >/tmp/.ipgroups
. /tmp/.ipgroups
cat /proc/scsi_target/iscsi_target/groups
echo -------------------
fi
AUTHLIST="/var/odyiscsi/etc/lunmappingodysys"
AUTH="/proc/scsi_target/iscsi_target/lunmapping"

if [ -f $AUTHLIST ]; then
echo "Restoring LUN MAPPING ..."
echo "reset" >$AUTH
cat $AUTHLIST|grep -v "^$"|grep -v "enable\|disable"|sed -e 's/.*/echo "append &">\/proc\/scsi_target\/iscsi_target\/lunmapping/g' >/tmp/.mapping
ENA=`cat $AUTHLIST|grep "enable\|disable"`
if [ "$ENA" = "enable" ]; then
echo "Enable lun-mapping:"
cat $AUTHLIST |grep -v "^$"| grep -v "enable\|disable" | sed -e 's/.*/append &/g'
. /tmp/.mapping 2>/tmp/.lun-mapping.err
echo "enable" >$AUTH 2>>/tmp/.lun-mapping.err
else
echo "Disable lun-mapping."
echo "disable" >$AUTH 2>>/tmp/.lun-mapping.err
fi
fi
if [ "`cat /tmp/.lun-mapping.err 2>/dev/null|wc -l`" -ne 0 ]; then
echo 
echo "Warning!"
echo "Error when restoring lun mapping rules, check your server restart or not."
echo "Then re-run /var/odyiscsi/init.local to load lun mapping rules."
read -p "Press Enter ..." -t 10
echo 
fi

#to disable rdac member disks.
/sbin/rdacdisk.sh

[ -x /etc/userdata/sysconfig/customdrv/extramap.sh ] && /etc/userdata/sysconfig/customdrv/extramap.sh

logger "$0 done"

#!/bin/bash
. /domain/etc/init/setupfunctions

[ -z "$1"  -o ! -f "$1" ] && echo "need sign file!" && exit 2
[ -z "$2" -o ! -d /sys/block/$2 ] && echo "/dev/$2 is not a block device, need block device as rootdisk." && exit 2
#check signfile
if [ -e /domain/root/.gnupg ];then
	cat $1|gpg -r XOSTE >/tmp/.rootsig 2>/dev/null
	[ $? -ne 0 ] && echo "bad sign file!" && exit 1	
fi
dd if=/dev/$2 bs=1k skip=16 count=16 of=/tmp/.oldsig 2>/dev/null
echo "@@ backup rootsig -- `date -Imin` @@"|tee -a /var/log/messages
cat /tmp/.oldsig|sed "s/^/@@ /g" >>/var/log/messages
dd if=$1 of=/dev/$2 bs=1k seek=16 count=16 2>/dev/null >/dev/null
[ $? -ne 0 ] && echo "sign rootdisk $2 fail!" && exit 3
echo "rootdisk $2 signed ok."
exit 0

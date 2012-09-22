#!/bin/bash
#read config from signed files
#$0 sigfile key
[ $# -lt 2 -o ! -e "$1" ] && echo "checksig.sh SIGFILE KEY" && exit 1
needver=`cat /encrypted/rootver`
rootver=`cat $1|gpg -u XOSTE 2>/dev/null|grep "^rootver="|sed "s/^rootver=//g"|sed "s/--@@--/\n/g"`
#check rootfs ver
if [ ! -z "$rootver" ];then
	cat $1|gpg -u XOSTE 2>/dev/null|grep "^rootver="|sed "s/^rootver=//g"|sed "s/--@@--/\n/g"|grep "^$needver$" >/dev/null
	[ $? -ne 0 ] && (
		[ $2 = "pcfg" -o $2 = "demopcfg" ] && echo "Signature need rootfs ver '$needver'!" >&2
	) && exit 1
fi
cat $1|gpg -u XOSTE 2>/dev/null|grep "^$2="|sed "s/^$2=//g"|sed "s/--@@--/\n/g"
exit ${PIPESTATUS[1]}

#!/bin/bash
#set -x
. /etc/setupfunctions
[ ! -z "$1" ] && dev=$1 || dev=`cat /etc/rootdisk`
part=$dev"2"
cat /proc/partitions|grep $part$ >/dev/null
[ $? -ne 0 ] && waitmsg "rootdisk parition $part not exists" && exit 1
mkdir /etc/userdata -p
fsck -y /dev/$part && mount /dev/$part /etc/userdata
[ $? -ne 0 ] && (
#	fsck /dev/$part
#	[ $? -eq 0 ] && mount /dev/$part /etc/userdata && exit 0
	reformat=`waitconfirm "Bad config filesystem, re-format $part and restore defualt[y/N]? "`
	[ "$reformat" = 'y' ] && (
		mkfs.ext3 /dev/$part
		exit $?
	) || exit 1
	[ $? -ne 0 ] && exit 1
	mount /dev/$part /etc/userdata
	exit $?
) || :
[ $? -ne 0 ] && waitmsg "Bad rootdisk config" && exit 1
[ ! -e /etc/userdata/sysconfig/hostname ] && (
	restore=`waitconfirm "Bad config data, restore default config?[y/N] "`
	[ "$restore" = "y" ] && (
		mkdir /etc/userdata/sysconfig  && cp -a /etc/default.config/* /etc/userdata/sysconfig
		[ $? -eq 0 ] && echo "Default config restored." && exit 0
		waitmsg "Failt to restore default config!" && exit 1
	)
	exit $?
)
mkdir -p /etc/userdata/log
rm /var/log -rf
ln -s /etc/userdata/log /var/log

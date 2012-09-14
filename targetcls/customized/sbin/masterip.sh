#!/bin/bash
checkdup ()
{
	arping -q -D -c3 -I ${1} ${2} 
	return $?
}

[ $# -ne 2 ] && exit

checkdup ${1} ${2}
ret=$?
case $ret in
0)
	ifconfig ${1}:999 ${2} netmask 255.255.255.0 up
	arping -q -c2 -A -b -s ${2} -I ${1} ${2}
	echo "master ip set ${2}@${1}."
	;;
1)
	echo "master ip already set by others."
	;;
*)
	echo "bad parameters."
	;;
esac
if [ $ret -lt 2 ];then
	echo "/sbin/masterip.sh ${1} ${2}" >/etc/userdata/sysconfig/masterip 
	chmod 755 /etc/userdata/sysconfig/masterip 2>/dev/null
fi
exit $ret

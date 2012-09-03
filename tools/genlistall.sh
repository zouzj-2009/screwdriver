#!/bin/bash
pkg=`basename $PWD`
[ -z "$1" ] && meta="./meta" || meta="../$1/meta"
[ -z "$1" ] && pkgpath=$pkg || pkgpath=$1
for file in `ls $meta`
do
	[ $file = "exclude" ] && continue
	echo "## Defined by $pkg.$file ##"
	if [ ! -z "`echo $file|grep '^[0-9]*\.inc\.'`" ];then
		inc=`echo $file|sed 's/^[0-9]*\.inc\.//g'`
		echo "## Include package $inc ##"
		./tools/genall $inc >../$pkg/$inc.trace
		[ $? -ne 0 ] && exit 1
		cat list.$inc.all
		continue
	fi
	[ -z "`echo $file|grep '^[0-9]*\.rpm\.'`" ] && cat $meta/$file && continue
	for rpm in `cat $meta/$file|grep -v ^#`
	do
		./tools/getrpmfiles $rpm $meta/exclude
		[ $? -ne 0 ] && exit 1
	done
done
#this is the last one!
echo "## $pkgpath.Customized ##"
./tools/getdir `dirname $PWD`"/$pkgpath/customized" $meta/exclude
[ $? -ne 0 ] && exit 1
exit 0

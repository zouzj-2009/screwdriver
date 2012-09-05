#!/bin/bash
[ ! -d tools  -o ! -d demo-cd ] && echo "run in sys-builder dir" && exit 1
[ -z "$1" ] && echo "need base ver name: redhat5|centos6|ubuntu12 ..." && exit 1

ver=$1
link_base(){
	for file in `ls ${1}`
	do
#		[ ! -d $file ] && continue;
		linkto=`echo $file|sed "s/\.$ver$//g"`
		[ $linkto = $file ] && continue;
		echo "line $file to $linkto ..."
		rm $linkto
		ln -s $file $linkto
	done
}

link_base .
cd tools
link_base .
cd -

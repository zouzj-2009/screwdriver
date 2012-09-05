#!/bin/bash
[ -z "$1" ] && echo "need modules.tgz path!" && exit 1
echo "Updating $1, using '`uname -r`' ..."
mkdir modules.old -p
rm modules.old/* -rf
uname=`uname -r`
mkdir modules.new -p
rm modules.new/* -rf
>modules.missing
echo "Extracting modules.tgz ..."
tar zxf $1 -C modules.old
for file in `find modules.old/lib`
do
	[ -d $file ] && continue
	mod=`basename $file`
	newmod=`find /lib/modules/$uname/ -name $mod`
	[ -z "$newmod" ] && echo "$mod: $file">>modules.missing && continue
	ndir=`dirname $newmod`
	mkdir modules.new/$ndir -p
	if [ -L $file ]; then
		cp -a $file modules.new/$ndir
		continue
	fi 
	echo "update $file ..."
	cp $newmod modules.new/$ndir
done
cp -a /lib/modules/$uname/modules.* modules.new/lib/modules/$uname
cd modules.new
tar zcvf ../$1 *
cd -

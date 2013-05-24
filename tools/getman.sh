#!/bin/bash
[ -z "$1" ] && echo "need man-name" && exit
man $1 >/dev/null
[ $? -ne 0 ] && exit
mkdir -p customized/fakeroot/docs/man
man $1|col -b >customized/fakeroot/docs/man/$1.txt

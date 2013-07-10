#!/bin/bash
[ ! -d initramfs ] && echo "initramfs not found" && exit 1
cd initramfs
find . | cpio -R 0:0 -H newc -o --quiet >../all.cpio
cd -

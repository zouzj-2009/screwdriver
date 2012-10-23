#!/bin/bash
rm ./initramfs/* -rf
rm ./deplibs/* -rf
set -x
tar --exclude='.git' --exclude 'build-from-source/*' --exclude 'source-pkgs' -zcvf /mnt/hgfs/vmshare/builder.backup.`date -Imin|sed 's/:/-/g'`.tgz *


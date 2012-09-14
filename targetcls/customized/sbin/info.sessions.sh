#!/bin/bash
[ ! -f /proc/scsi_target/sessions ] && exit
cat /proc/scsi_target/sessions|grep -v NOPER

#!/bin/bash
if [ "$1" = "-t" ];then
echo "id     h c s l     capacity vendor               type          state"
echo "------------------------------------------------ ------------- ---------"
fi
cat /proc/scsi_target/scsi_target 2>/dev/null|awk '/Target:/{
	printf "%-5s %-8s %8s%s " , $2, $4, $6, $7
	getline
	printf "%-20s ",$2" "$3
	getline 
	print $2
}'|sed 's/(scsi\|,\|)/ /g'|awk '{printf $0" "
system("echo -n `cat /sys/class/scsi_device/"$2":"$3":"$4":"$5"/device/state`")
system("/sbin/iswb.sh "$1)
printf "\n"
}'

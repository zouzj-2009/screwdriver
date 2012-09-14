#!/bin/bash
cd /www/cgi-bin/
echo "initator-ip     target_ip       target-id recv(B/s)  send(B/s)  rx_pid"
echo "-------------------------------------------------------------------------------" 
./iscsiinfo.sh /proc/scsi_target/iscsi_target/0|awk '{printf "%-15s %-15s %-9s %-10s %-10s %-5s\n", $8, $10, $1, $22, $24, $13}'
cd -

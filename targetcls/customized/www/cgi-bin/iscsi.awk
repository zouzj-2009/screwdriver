{
LNMOD=29
if (PRTHEAD==1) {
	print "tid(1) host(2) channel(3) sid(4) lun(5) conn-num(6) cid(7) remo-ip(8) remo-port(9) local-ip(10) local-port(11) isactive(12) local-port(13) rxpid(14) txpid(15) iscsi_cmds(16) tsih(17) queue_depth(18) maxsn(19) exp_sn(20) cmd_sn(21) recv(22) recvx(23) send(24) sendx(25) errors(26) permition(27) MaxConnections(28) TargetName(29) InitiatorName(30) ImmediateData(31) MaxBurstLength(32) FirstBurstLength(33) DefaultTime2Retain(34) DefaultTime2Retain(35) MaxOutstandingR2T(36) DataPDUInOrder(37) DataSequenceInOrder(38) ErrorRecoveryLevel(39) SessionType(40) TargetPortalGroupTag(41)"
	exit
}else{
	if (NR%LNMOD < 15) gsub("\\(|\\)|,|:"," ",$0)
	#target id host channel sid lun
	if ((NR%LNMOD)==1) printf $4" "$5" "$6" "$7" "$8
	#number of connection
	if ((NR%LNMOD)==2) printf " "$3
	#cid remoteip port localip port isactive
	if ((NR%LNMOD)==3) printf " "$2" "$3" "$4" "$6" "$7" "$10
	#rxpid txpid 
	if ((NR%LNMOD)==4) printf " "$4" "$8
	#iscsi cmds
	if ((NR%LNMOD)==5) printf " "$4
	#tsih
	if ((NR%LNMOD)==6) printf " "$3
	#queue_depth
	if ((NR%LNMOD)==7) printf " "$3
	#maxsn
	if ((NR%LNMOD)==8) printf " "$3
	#exp_cmd_sn
	if ((NR%LNMOD)==9) printf " "$3
	#cmd_sn
	if ((NR%LNMOD)==10) printf " "$3
	#recv recvx send sendx 
	if ((NR%LNMOD)==11) printf " "$2" "$3" "$6" "$7
	#errors
	if ((NR%LNMOD)==12) printf " "$3
	#access level
	if ((NR%LNMOD)==13) printf " "$4
	# session-wide parameters
	if ((NR%LNMOD)>=15 || (NR>0 && NR%LNMOD ==0)) printf " "$2
	if ((NR%LNMOD) == 0 && NR  > 0) printf "\n" 
	}
}

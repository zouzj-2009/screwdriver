cat $1|grep "session for" -A28|grep -v "^--"|awk -f iscsi.awk

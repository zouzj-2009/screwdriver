/Memory Device/{
	getline
	if ($3 == "Unknown"){
		for(i=0;i<14;i++) getline
	}else{
		print "Memory Device"
		print $0
	}	
}
{
	print $0
}

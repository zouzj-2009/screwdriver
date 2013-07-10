cat modules/2.6.32-220.el6.x86_64/modules.dep|sed "s/\(kernel\|extra\|addon\|^misc\|: misc\)/\/lib\/modules\/`uname -r`\/\1/g" >modules.dep

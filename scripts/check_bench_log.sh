grep -ir "SSL read failed" /tmp/log1  &>/dev/null ; echo $?

#cat /tmp/log1  | grep "Requests per second" | awk '{print $4}' 

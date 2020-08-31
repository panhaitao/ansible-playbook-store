grep -ir "SSL read failed" /tmp/log  &>/dev/null ; echo $?
cat /tmp/log  | grep "Requests per second" | awk '{print $4}' 

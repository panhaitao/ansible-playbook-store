#!/bin/bash
for i in $(curl 127.0.0.1:60080/v2/_catalog?n=500 2>/dev/null | sed -e 's/^.*\[//' -e 's/\].*$//' -e 's/,/\n/g' -e s'/"//g'); do 
  for j in $(curl 127.0.0.1:60080/v2/$i/tags/list 2>/dev/null | jq ".tags|keys" | sed -e '1d' -e '$d' -e 's/,//g') ; 
    do echo $i:$(curl 127.0.0.1:60080/v2/$i/tags/list 2>/dev/null |jq ".tags[$j]" | sed 's/"//g') ; 
    done ;
done

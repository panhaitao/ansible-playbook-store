#!/bin/bash

##
LOAD_STD=`nproc`
LOAD_1=`uptime | awk -F"load average:" '{print $2}' | awk -F, '{print $1'}`
LOAD_5=`uptime | awk -F"load average:" '{print $2}' | awk -F, '{print $2'}`
LOAD_15=`uptime | awk -F"load average:" '{print $2}' | awk -F, '{print $3'}`

mem_total=`free -m | grep Mem | awk '{print $2}'`
mem_used=`free -m | grep Mem | awk '{print $3}'`
percent=`awk -v total=$mem_total -v used=$mem_used 'BEGIN {printf "%.0f\n",used/total*100}'`

result=/tmp/$$
> $result
df -h | grep -v "/var/lib/docker" |  awk 'NR>1 { print $5" "$6 }' | while read line
do
    part_use=`echo $line | awk '{print $1}' | awk -F% '{print $1}'`
    part_mount=`echo $line | awk '{print $2}'`
 
    if [[ ${part_use} -ge 70 ]];then
            echo " $part_mount used is $part_use % " >> $result
    fi
done

docker_part=`df  "/var/lib/docker" -h |  awk 'NR>1 { print $5 }' | awk -F% '{print $1}'`
if [[ ${docker_part} -ge 70 ]];then
            echo "/var/lib/docker used is $part_use % " >> $result
fi

DiskUsed=`cat $result`
if [[ "$DiskUsed" == "" ]];then
  DiskStat=ok
else
  DiskStat=Warning
fi


printf "`hostname -i| awk '{print $NF}'`\n"
printf "%-10s %-10s %-10s %-10s %-10s %s\n" CpuCores LOAD_1 LOAD_5 LOAD_15 mem_used "DiskStat(<70%)"
printf "%-10s %-10s %-10s %-10s %-10s %s\n" $LOAD_STD $LOAD_1 $LOAD_5 $LOAD_15 ${percent}/100 $DiskStat
echo $DiskUsed

## 比较大小备用脚本
## echo $percent 80 | awk '{ if($1>=$2) {printf" system mem_used percent is %.0f/100 more than: %.0f/100 \n",$1,$2} }'

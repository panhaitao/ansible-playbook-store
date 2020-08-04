#!/bin/bash
# filename: check_cluster_nfs_pv.sh
 
df -h  |  awk '{ print $2"" $5" "$6 }' | while read line
do
        part_size=`echo $line | awk '{print $1}' | awk -F% '{print $1}'`
        part_use=`echo $line | awk '{print $2}'  | awk -F% '{print $1}'`
        part_mount=`echo $line | awk '{print $3}'| awk -F "nfs/" '{print $2}'`
 
        echo -e "$part_mount $part_size $part_use%"
done

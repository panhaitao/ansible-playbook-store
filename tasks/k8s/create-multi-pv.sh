#!/bin/bash

cat /var/playbook/pv.list | awk 'NR>1 { print $2" "$3" "$7 }' | while read line
do
  PV_NAME=`echo $line | awk '{print $1}'`
  PV_SIZE=`echo $line | awk '{print $2}'`
  NAS_IP=`echo $line | awk '{print $3}' | awk -F: '{print $1}'`
  NAS_PATH=`echo $line | awk '{print $3}' | awk -F: '{print $2}'`

ansible-playbook -i hosts/td-devk8s tasks/add-k8s-pv.yaml -e master=devk8-m01 -e pv_name=$PV_NAME -e pv_size=$PV_SIZE -e nas_ip=$NAS_IP -e nas_path=$NAS_PATH -D

done 

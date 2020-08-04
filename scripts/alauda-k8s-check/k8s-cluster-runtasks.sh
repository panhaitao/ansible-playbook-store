#!/bin/bash
TIME=`date +%F-%H%M`
RUN_PATH=`pwd`
E_LOG=${LOG_PATH}/e-cluser-${TIME}  
P_LOG=${LOG_PATH}/p-cluser-${TIME}  

bash ${RUN_PATH}/tasks/etcd-backup.sh &>/dev/null &
bash ${RUN_PATH}/tasks/check_e-cluster.sh &> ${E_LOG}.log && bash ${RUN_PATH}/k8s-cluster-report-ana.sh  ${E_LOG}.log  e_log-${TIME}.report &
bash ${RUN_PATH}/tasks/check_p-cluster.sh &> ${P_LOG}.log && bash ${RUN_PATH}/k8s-cluster-report-ana.sh  ${P_LOG}.log  p_log-${TIME}.report &

#!/bin/bash

export cluster=$1
export master=$2

if [[ "$cluster" == "" || "$master" == "" ]];then
{
  echo "script args is empty!!!"
  echo "example:"
  echo "ansible_run.sh as-global as-global-m01"
  exit 1
}
fi

ansible -i hosts/$cluster all -m script -a "check_os_status.sh" -o
ansible -i hosts/$cluster $master -m script -a "check_cluster_nfs_pv.sh" -o
ansible -i hosts/$cluster $master -m shell -a "kubectl get cs"
ansible -i hosts/$cluster $master -m shell -a "kubectl get nodes"
ansible -i hosts/$cluster $master -m shell -a "kubectl get pods --all-namespaces | grep -v Running"
ansible -i hosts/$cluster $master -m shell -a "df -hs /buffer/alauda/" -o


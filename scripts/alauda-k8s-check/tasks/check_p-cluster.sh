#!/bin/sh
ansible pmaster       -m script -a scripts/check_k8s_cluser.sh
ansible pmaster       -m script -a scripts/check_system_stat.sh
ansible pnode         -m script -a scripts/check_system_stat.sh
ansible 20.20.101.211 -m shell  -a "ls -lh /root/etcd-bak/*"
ansible 20.20.101.211 -m shell  -a "kubectl get nodes"
ansible 20.20.101.211 -m shell  -a "kubectl get pods --all-namespaces | grep -v Running"

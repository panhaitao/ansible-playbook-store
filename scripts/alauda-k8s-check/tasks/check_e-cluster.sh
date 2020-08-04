#!/bin/sh
ansible emaster      -m script -a scripts/check_k8s_cluser.sh
ansible emaster      -m script -a scripts/check_system_stat.sh
ansible enode        -m script -a scripts/check_system_stat.sh
ansible 10.71.15.210 -m shell  -a "ls -lh /root/etcd-bak/*"
ansible 10.71.15.210 -m shell  -a "kubectl get nodes"
ansible 10.71.15.210 -m shell  -a "kubectl get pods --all-namespaces | grep -v Running"

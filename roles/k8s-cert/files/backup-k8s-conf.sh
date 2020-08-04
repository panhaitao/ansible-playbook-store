#!/bin/bash

mkdir -pv /root/tmp/

if [ -d "/etc/kubernetes" ]; then
    cp -rf /etc/kubernetes /root/tmp/etc_kubernetes_`date '+%Y%m%d_%H.%M.%S'`
fi

if [ -d "/etc/kubeadm" ]; then
  cp -rf /etc/kubeadm /root/tmp/etc_kubeadm_`date '+%Y%m%d_%H.%M.%S'`
fi

if [ -d "/etc/kubeadmin" ]; then
  cp -rf /etc/kubeadmin /root/tmp/etc_kubeadmin_`date '+%Y%m%d_%H.%M.%S'`
fi

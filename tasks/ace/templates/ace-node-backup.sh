#!/bin/sh
mkdir -pv /root/backup/kubernetes-{{ pre_version }}
unalias cp
cp -av /etc/kubernetes/ /root/backup/kubernetes-{{ pre_version }}
cp `which kubelet` /root/backup/kubelet-{{ pre_version }} -f
cp `which kubectl` /root/backup/kubectl-{{ pre_version }} -f

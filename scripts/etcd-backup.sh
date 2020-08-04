#!/bin/bash
IP=10.213.255.4
BACKUP=/alauda/backup/etcd_backup/
export ETCDCTL_API=3
etcdctl --endpoints=https://$IP:2379      \
--cacert /etc/kubernetes/pki/etcd/ca.crt  \
--cert /etc/kubernetes/pki/etcd/peer.crt  \
--key /etc/kubernetes/pki/etcd/peer.key   \
snapshot save $BACKUP/snap-$(date +%Y%m%d%H%M).db

a=(`ls -ls /alauda/backup/etcd_backup/ | awk '{print $NF}' | sed 1d`)
if [ ${#a[@]} -gt 20 ];
then
  for ((i=21; i<=${#a[@]}; i++));
  do
    rm -f /alauda/backup/etcd_backup/${a[i]}
  done
fi

#!/bin/bash
ansible emaster -m shell -a "hostname && mkdir -pv /root/etcd-bak && ls -lh /root/etcd-bak/*"
ansible pmaster -m shell -a "hostname && mkdir -pv /root/etcd-bak && ls -lh /root/etcd-bak/*"
ansible 10.71.15.210 -m shell -a "bash /root/etcd-bak/etcd-backup.sh"
ansible 20.20.101.211 -m shell -a "bash /root/etcd-bak/etcd-backup.sh"

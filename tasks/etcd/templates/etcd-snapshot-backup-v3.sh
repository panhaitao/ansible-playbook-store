#!/bin/sh

ETCDCTL_API=3 /root/etcdctl --endpoints=https://[{{ hostvars[inventory_hostname].ansible_ssh_host }}]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt \
--key=/etc/kubernetes/pki/etcd/healthcheck-client.key snapshot save /root/backup/{{ pre_version }}-etcd-v3-snapshot.db

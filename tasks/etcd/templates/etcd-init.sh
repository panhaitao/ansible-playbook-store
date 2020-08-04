{%- set pkg_ip = pkg_ip -%}
#!/bin/bash

systemctl stop kubelet
rm -rvf /var/lib/etcd/*

docker run -d -t -i --net=host --name=etcd-init \
-v /var/lib/etcd/:/var/lib/etcd/ {{ pkg_ip }}:5000/etcd-amd64:3.1.11   \
/bin/sh -c "/usr/local/bin/etcd --name={{ inventory_hostname }}                                       \
--listen-peer-urls=http://{{ hostvars[inventory_hostname].ansible_ssh_host }}:2380                    \
--initial-advertise-peer-urls=http://{{ hostvars[inventory_hostname].ansible_ssh_host }}:2380         \
--listen-client-urls=http://{{ hostvars[inventory_hostname].ansible_ssh_host }}:2379                  \
--advertise-client-urls=http://{{ hostvars[inventory_hostname].ansible_ssh_host }}:2379               \
--initial-cluster-token=etcd-init                                                                     \
--initial-cluster-state=new                                                                           \
--data-dir=/var/lib/etcd                                                                              \
--initial-cluster={%- for item in groups['master'] -%}{{ item }}=http://{{ hostvars[item]['ansible_ssh_host'] }}:2380{% if not loop.last %},{% endif %} {%- endfor %}"

docker rm etcd-init -f
systemctl restart kubelet

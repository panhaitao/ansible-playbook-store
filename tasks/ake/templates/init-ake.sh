#!/bin/bash
docker load < /root/mini-alauda/distribution.tar

#docker load < /root/mini-alauda/kaldr-190415.tar
#docker load < /root/mini-alauda/flannel-cni.tar.gz
#docker load < /root/mini-alauda/flannel.tar.gz
#docker load < /root/mini-alauda/kubedns-amd64-1.4.tar.gz
#docker load < /root/mini-alauda/kubedns-amd64.tar.gz
#docker rmi {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/alaudaorg/kaldr:v1.5
#
#docker tag index.alauda.cn/alaudaorg/kaldr:190415       {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/alaudaorg/kaldr:v1.5
#docker tag index.alauda.cn/claas/flannel:v0.9.1         {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/claas/flannel:v0.9.1
#docker tag index.alauda.cn/claas/flannel-cni:v0.3.0     {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/claas/flannel-cni:v0.3.0
#docker tag index.alauda.cn/claas/kubedns-amd64:1.9      {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/claas/kubedns-amd64:1.9
#docker tag index.alauda.cn/claas/kube-dnsmasq-amd64:1.4 {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/claas/kube-dnsmasq-amd64:1.4
#
#docker push {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/alaudaorg/kaldr:v1.5
#docker push {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/claas/flannel:v0.9.1
#docker push {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/claas/flannel-cni:v0.3.0
#docker push {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/claas/kubedns-amd64:1.9
#docker push {{ hostvars[inventory_hostname].ansible_ssh_host }}:60080/claas/kube-dnsmasq-amd64:1.4

bash /root/mini-alauda/up-mini-alauda.sh -osd --network-interface=eth0 --dockercfg=/root/mini-alauda/daemon.json

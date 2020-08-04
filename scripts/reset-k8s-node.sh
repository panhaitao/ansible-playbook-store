#!/bin/bash
set -x
set +e
/usr/local/bin/kubeadm reset
/usr/local/bin/kubeadm reset
/usr/local/bin/kubeadm reset
systemctl daemon-reload
systemctl stop kubelet
rm -rf /etc/systemd/system/kubelet.service
rm -rf /etc/systemd/system/kubelet.service.d
rm -rf /usr/local/bin/kubelet
rm -rf /usr/local/bin/kubeadm
rm -rf /usr/local/bin/kubectl
rm -rf /usr/local/sbin/kubelet
rm -rf /usr/local/sbin/kubeadm
rm -rf /usr/local/sbin/kubectl
docker ps -qa|xargs docker rm -f
rm -rf /etc/kube*
rm -rf /var/lib/kubelet
rm -rf /etc/etcd/
rm -rf /etc/cni/net.d
rm -rf /var/lib/etcd
rm -rf /opt/cni/bin
ip link set flannel.1 down
ip link set cni0 down
ip link delete flannel.1
ip link delete cni0

rm -rf $HOME/.kube
rm -rf $HOME/.helm
rm -rf /root/.helm
rm -rf /root/.kube

df -l --output=target |grep ^/var/lib/kubelet |grep subpath | xargs -r umount
df -l --output=target |grep ^/var/lib/kubelet | xargs -r umount
ip link del ipvlan0
ip link del macvlan0
ip link del tunl0
for i in $(arp -an |grep 'PERM on macvlan0' | awk '{print $2}' | sed -e 's/(//g' -e 's/)//g') ; do arp -i macvlan0 -d $i; done;

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
docker ps -a -q | xargs docker rm -f
systemctl stop kubelet
systemctl stop docker
rm -rvf /var/lib/docker/ /var/lib/etcd /var/lib/kubelet
rm -rvf /etc/systemd/system/kubelet.service /etc/kubernetes/ ~/.kube/ ~/.helm /etc/yum.repos.d/*
systemctl restart docker

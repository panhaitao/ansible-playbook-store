#!/usr/bin/env bash
set -e
set -x

restart_dirge() {
echo "restart dirge"
 cat > /alauda/restart_dirge.sh << EOF
sleep 3;
service dirge restart
EOF
chmod 755 /alauda/restart_dirge.sh
nohup /alauda/restart_dirge.sh &
}

remove_iptables() {
if [ ! -f /run/flannel/subnet.env ]
  then
    echo "flannel is empty"
else
  flannel=`cat /run/flannel/subnet.env|grep "FLANNEL_SUBNET" | awk -F= '{print $2}'`
  pre=`echo ${flannel%.*}`
  post=`echo ${flannel##*/}`
  cidr=$pre".0/"$post
  echo "cidr is: $cidr"
  iptables-save | grep $cidr | sed 's/-A/iptables -t nat -D/'|bash
fi
}

get_system()
{
  ubuntu=`cat /etc/*-release|grep Ubuntu|wc -l`
  centos=`cat /etc/*-release|grep CentOS|wc -l`
  redhat=`cat /etc/*-release|grep "Red Hat"|wc -l`
  if [ "$ubuntu" -gt 0 ]
  then
    echo "ubuntu"
  elif [ "$redhat" -gt 0 ]
  then
    echo "redhat"
  elif [ "$centos" -gt 0 ]
  then
    echo "centos"
  else
    echo "Can't detect system version!"
    exit
  fi
}

clear_kubelet_setting()
{
  system=`get_system`
  if [[ $system == "ubuntu" ]]
    then
      dpkg -P kubeadm
      dpkg -P kubectl
      dpkg -P kubelet
      dpkg -P kubernetes-cni
      rm -rf /etc/systemd/system/kubelet.service*
      rm -rf /lib/systemd/system/kubelet.service*
  else
      yum erase -y kubeadm
      yum erase -y kubectl
      yum erase -y kubelet
      yum erase -y kubernetes-cni
      rm -rf /etc/systemd/system/kubelet.service*
  fi
}

command_exists() {
    command -v "$@" > /dev/null 2>&1
}

#cd /var/lib/cni/networks/cbr0; for hash in $(tail -n +1 * | grep '^[A-Za-z0-9]*$' | cut -c 1-8); do if [ -z $(docker ps -a | grep $hash | awk '{print $1}') ]; then grep -irl $hash ./; fi; done | xargs rm


#if command_exists kubeadm
#  then
#    kubeadm reset
#    kubeadm reset
#    kubeadm reset
#fi
service docker stop

umount /dev/sdb
mkfs.xfs /dev/sdb -f
mount -a

# Remove all flannel iptables
remove_iptables

set +e

#kubeadm reset y
mkdir -p /tmp/kubernetes
mkdir -p /tmp/kubelet
mv /etc/kubernetes/* /tmp/kubernetes
mv /var/lib/kubelet/* /tmp/kubelet
rm -rf /tmp/kubernetes/*
rm -rf /tmp/kubelet/*

set -e
rm -rf /var/lib/cni/*
rm -rf /etc/cni/net.d/*
rm -rf /alauda/etcd/*
rm -rf /alauda/src
mkdir -p /alauda/src

#service docker restart
service docker start

regex="\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\/([1-2][0-9]|3[0-1]|[1-9])\b"

set +e
flannel_cidr=`cat /run/flannel/subnet.env |grep FLANNEL_NETWORK=|cut -d = -f 2`

echo "flannel cidr:" $flannel_cidr

flannel_flag=`echo $flannel_cidr | egrep $regex | wc -l`
if [ $flannel_flag -eq 1 ]
  then
  ip addr del $flannel_cidr dev flannel.1
fi

cni_cidr=`cat /run/flannel/subnet.env |grep FLANNEL_SUBNET=|cut -d = -f 2`
echo "cni cidr:" $cni_cidr

cni_flag=`echo $cni_cidr | egrep $regex | wc -l`
if [ $cni_flag -eq 1 ]
  then
  ip addr del $cni_cidr dev cni0
fi

rm -rf /run/flannel/*

ip link set flannel.1 down
ip link set cni0 down
ip link delete flannel.1
ip link delete cni0

clear_kubelet_setting
restart_dirge
set +e
ps -ef|grep -v grep|grep "/alauda/src/start.sh"|awk '{print $2}'|xargs kill -9
ps -ef|grep -v grep|grep "/alauda/src/func_"|awk '{print $2}'|xargs kill -9
ps -ef|grep -v grep|grep "kubeadm"|awk '{print $2}'|xargs kill -9
set -e

rm -rvf /var/lib/etcd ~/.kube/ /etc/kube* /root/.helm /etc/systemd/system/kubelet.service
echo "cleanup successfully"

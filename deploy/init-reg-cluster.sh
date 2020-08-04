
ansible-playbook -i hosts/cpaas-2.8-cluster tasks/hosts/hosts.yaml -e hostgroup=all -D 
ansible-playbook -i hosts/cpaas-2.8-cluster tasks/hosts/change-hostname.yaml -e hostgroup=all -D
ansible -i hosts/cpaas-2.8-cluster master -m script -a "cleanup.sh"
ansible -i hosts/cpaas-2.8-cluster node -m script -a "cleanup.sh"

ansible -i hosts/cpaas-2.8-cluster master -m shell -a "yum remove libselinux-devel libsepol-devel subscription-manager* -y"
ansible -i hosts/cpaas-2.8-cluster master -m shell -a "rm -rvf /etc/yum.repos.d/; mkdir /etc/yum.repos.d/; ls /etc/yum.repos.d/"
ansible -i hosts/cpaas-2.8-cluster node -m shell -a "yum remove libselinux-devel libsepol-devel subscription-manager* -y"
ansible -i hosts/cpaas-2.8-cluster node -m shell -a "rm -rvf /etc/yum.repos.d/; mkdir /etc/yum.repos.d/; ls /etc/yum.repos.d/"

## clean all node
ansible -i hosts/cpaas-2.8-cluster master -m shell -a "rm -rvf /var/lib/etcd /var/lib/kubelet/ /etc/kubernetes/ /etc/kubeadm/ /etc/systemd/system/kubelet.service /root/.kube"
ansible -i hosts/cpaas-2.8-cluster node -m shell -a "rm -rvf /var/lib/etcd /var/lib/kubelet/ /etc/kubernetes/ /etc/kubeadm/ /etc/systemd/system/kubelet.service /root/.kube"

## reboot all node
#ansible -i hosts/cpaas-2.8-cluster master -m shell -a "reboot"
#ansible -i hosts/cpaas-2.8-cluster node -m shell -a "reboot"

## import cluster
#kubectl describe secrets clusterrole-aggregation-controller-token-xmmts -n kube-system 

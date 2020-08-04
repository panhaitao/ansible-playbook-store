#ansible-playbook -i hosts/cpaas-2.8 tasks/hosts/hosts.yaml -e hostgroup=all -D 
#ansible-playbook -i hosts/cpaas-2.8 tasks/hosts/change-hostname.yaml -e hostgroup=all -D
## clean all node
ansible -i hosts/cpaas-2.8 master -m script -a "cleanup.sh"
ansible -i hosts/cpaas-2.8 node -m script -a "cleanup.sh"
## 
ansible -i hosts/cpaas-2.8 master -m shell -a "systemctl stop kubelet"
ansible -i hosts/cpaas-2.8 master -m shell -a "docker ps -a |xargs docker rm -f"
ansible -i hosts/cpaas-2.8 master -m shell -a "yum remove libselinux-devel libsepol-devel subscription-manager* -y"
ansible -i hosts/cpaas-2.8 master -m shell -a "rm -rvf /etc/yum.repos.d/; mkdir /etc/yum.repos.d/; ls /etc/yum.repos.d/"
ansible -i hosts/cpaas-2.8 master -m shell -a "rm -rvf /var/lib/etcd /var/lib/kubelet/ /var/lib/docker /etc/kubernetes/ /etc/kubeadm/ /etc/systemd/system/kubelet.service /root/.kube /root/.helm rm -rvf /alauda/*"
ansible -i hosts/cpaas-2.8 node -m shell -a "systemctl stop kubelet"
ansible -i hosts/cpaas-2.8 node -m shell -a "docker ps -a |xargs docker rm -f"
ansible -i hosts/cpaas-2.8 node -m shell -a "yum remove libselinux-devel libsepol-devel subscription-manager* -y"
ansible -i hosts/cpaas-2.8 node -m shell -a "rm -rvf /etc/yum.repos.d/; mkdir /etc/yum.repos.d/; ls /etc/yum.repos.d/"
ansible -i hosts/cpaas-2.8 node -m shell -a "rm -rvf /var/lib/etcd /var/lib/kubelet/ /var/lib/docker /etc/kubernetes/ /etc/kubeadm/ /etc/systemd/system/kubelet.service /root/.kube /root/.helm rm -rvf /alauda/*"
## reboot all node
ansible -i hosts/cpaas-2.8 master -m shell -a "reboot"
ansible -i hosts/cpaas-2.8 node -m shell -a "reboot"

#ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s05 -D 
#ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s05 -D
#ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s05 -D

#ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s06 -D 
#ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s06 -D
#ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s06 -D

#ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s07 -D 
#ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s07 -D
#ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s07 -D

#ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s08 -D 
#ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s08 -D
#ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s08 -D

#ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s09 -D 
#ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s09 -D
#ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s09 -D

#ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s10 -D 
#ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s10 -D
#ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s10 -D

#ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s11 -D 
#ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s11 -D
#ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s11 -D

#ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s12 -D 
#ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s12 -D
#ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s12 -D

#ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s13 -D 
#ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s13 -D
#ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s13 -D

ansible-playbook -i hosts/as-sck8s tasks/docker/install-docker.yaml -e group=as-sck8s-s14 -D 
ansible-playbook -i hosts/as-sck8s tasks/cni-nsx-t/cni-nsx-t.yaml -e group=as-sck8s-s14 -D
ansible-playbook -i hosts/as-sck8s tasks/k8s-1.13.4/install-k8s.yaml -e master_host=as-sck8s-m01 -e node=as-sck8s-s14 -D


#kubectl label node --overwrite as-sck8s-s05 node-role.kubernetes.io/node=

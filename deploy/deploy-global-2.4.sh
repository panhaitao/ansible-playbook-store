ansible -i hosts/cpaas-2.8 init -m shell -a "cd /alauda/mnt/package/ace/ace_pack_20190308 && bash ACP/cleanup.sh"
ansible -i hosts/cpaas-2.8 init -m shell -a "cd /alauda/mnt/package/ace/ace_pack_20190308 && ./up-alaudaee.sh --network-interface=ens192 --kube_controlplane_endpoint 10.213.109.11 --alaudaee-domain-name 10.213.109.12 --db-info='DB_HOST=10.213.107.205;DB_PORT=3309;DB_USER=alauda;DB_PASSWORD=Mysql@123;DB_ENGINE=mysql'"
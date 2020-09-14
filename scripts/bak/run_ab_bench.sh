ansible -i hosts/ab-bench a -m script -a scripts/http_load_domain1.sh
ansible -i hosts/ab-bench b -m script -a scripts/http_load_domain2.sh
#ansible -i hosts/ab-bench all -m script -a scripts/http_load.sh

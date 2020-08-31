#ansible -i hosts/ab-bench a,b,c -m script -a scripts/http_load.sh
ansible -i hosts/ab-bench all -m script -a scripts/http_load.sh

ansible -i hosts/http_load all -m shell -a "pkill ab"
ansible -i hosts/http_load all -m shell -a "pkill jmeter-server; pkill jmeter"

ansible -i hosts/ab-bench all -m shell -a "pkill ab"
ansible -i hosts/ab-bench all -m shell -a "pkill jmeter-server; pkill jmeter"
ansible -i hosts/ab-bench2 all -m shell -a "pkill jmeter-server; pkill jmeter"
ansible -i hosts/ab-bench3 all -m shell -a "pkill jmeter-server; pkill jmeter"

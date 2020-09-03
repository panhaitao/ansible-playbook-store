#!/bin/bash

hosts_name=http_load

cat > hosts/$hosts_name <<EOF  
[all]
EOF

for N in `seq 1 40`
do
  name=ab-$N
  ip=`python3  scripts/create_uhost.py`

cat >> hosts/$hosts_name <<EOF  
$name			ansible_ssh_host=$ip
EOF
  sleep 1
done

cat >> hosts/$hosts_name <<EOF  
ops                     ansible_ssh_host=127.0.0.1

[all:vars]
ansible_connection=ssh
ansible_ssh_user=root
ansible_ssh_pass=""
EOF



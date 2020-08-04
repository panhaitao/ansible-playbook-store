#!/bin/sh
chmod 755 /root/ake && /root/ake addnodes --nodes={{ hostvars[inventory_hostname].ansible_ssh_host }} --ssh-port=22 --ssh-username={{ ansible_ssh_user }}  --ssh-password={{ ansible_ssh_pass }} --token={{ hostvars[master_host].join_token }} --apiserver={{ apiserver }} --registry={{ init_ip }}:60080 --pkg-repo={{ pkgrepo }} --debug  --dockercfg=/etc/docker/daemon.json  -kv v1.13.3

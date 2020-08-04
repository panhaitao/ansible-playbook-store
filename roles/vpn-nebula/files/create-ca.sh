#!/bin/bash
export PATH=$PATH:/usr/local/bin

mkdir -pv /opt/pki/ && cd /opt/pki/

if [[ ! -f ca.key ]];then
    nebula-cert ca -name "Nebula Mesh Network"
fi
chmod 0755 /opt/ca.crt

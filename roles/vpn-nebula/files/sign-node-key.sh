#!/bin/bash

export name=$1
export ipv4=$2

if [[ "$name" == "" || "$ipv4" == "" ]]
then
  echo "script args is empty!!!"
  exit 1
fi

export PATH=$PATH:/usr/local/bin
mkdir -pv /opt/pki/ && cd /opt/pki/

if [[ -f /opt/pki/${name}.key && -f  /opt/pki/${name}.crt ]]
then
  "${name} cert is existd"  
else
  nebula-cert sign -name $name  -ip $ipv4
  chmod 755 /opt/pki/${name}*
fi

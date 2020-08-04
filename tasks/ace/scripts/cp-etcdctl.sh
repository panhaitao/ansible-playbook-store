#!/bin/bash
set -x
ID=`docker ps -a | grep etcd | head -n1 | awk '{print $1}'`
docker cp ${ID}:/usr/local/bin/etcdctl /root/

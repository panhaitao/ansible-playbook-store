#!/bin/sh

docker load -i /tmp/nsx-ncp-rhel-2.4.0.12511604.tar
docker tag registry.local/2.4.0.12511604/nsx-ncp-rhel:latest {{ init_ip }}:60080/nsx-ncp-rhel:latest
docker push {{ init_ip }}:60080/nsx-ncp-rhel:latest

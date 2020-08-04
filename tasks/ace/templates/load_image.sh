docker load < /root/link-1.14.11.tar.gz
docker tag index.alauda.cn/alaudak8s/link:v1.4.11 {{ init_ip }}:60080/alaudak8s/link:v1.4.11
docker push {{ init_ip }}:60080/alaudak8s/link:v1.4.11 

docker load < /root/portal-v1.3.6.tar.gz
docker tag index.alauda.cn/alaudak8s/portal:v1.3.6  {{ init_ip }}:60080/alaudak8s/portal:v1.3.6
docker push {{ init_ip }}:60080/alaudak8s/portal:v1.3.6

docker load < /root/dex-v0.1.16.tar.gz 
docker tag index.alauda.cn/alaudak8s/dex:v0.1.16  {{ init_ip }}:60080/alaudak8s/dex:v0.1.16
docker push {{ init_ip }}:60080/alaudak8s/dex:v0.1.16

docker load < /root/morgans.tar.gz
docker tag index.alauda.cn/alaudaorg/morgans:bf56f662f2b9df0cec2c4bc730589968de1afed4  {{ init_ip }}:60080/alaudaorg/morgans:bf56f662f2b9df0cec2c4bc730589968de1afed4
docker push {{ init_ip }}:60080/alaudaorg/morgans:bf56f662f2b9df0cec2c4bc730589968de1afed4

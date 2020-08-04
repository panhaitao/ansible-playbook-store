#!/bin/sh

OLD_TAG="index.alauda.cn/claas/"
NEW_TAG="{{ init_ip }}:60080/claas/"

for f in `ls /tmp/k8s/*.gz`
do 
    docker load -i $f
done
     
for i in `cat /tmp/k8s/images.txt`
do
    docker tag ${OLD_TAG}${i} ${NEW_TAG}${i} 
    docker push ${NEW_TAG}${i} 
done

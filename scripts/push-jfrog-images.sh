#!/bin/sh

#export DEST_TAG=10.213.107.196:30500/jfrog
export DEST_TAG=$1

if [ ! -n $DEST_TAG ];then
	echo "the DEST_TAG arg is NULL"
        echo -e "\t example: push-jfrog-images.sh 10.213.107.196:30500/jfrog "
	echo "prog will be exit"
	exit 1 
else

    docker tag docker.bintray.io/jfrog/distribution-installer:1.6.1               ${DEST_TAG}/distribution-installer:1.6.1        
    docker tag docker.bintray.io/jfrog/distribution-distributor:1.6.1             ${DEST_TAG}/distribution-distributor:1.6.1
    docker tag docker.bintray.io/jfrog/distribution-distribution:1.6.1            ${DEST_TAG}/distribution-distribution:1.6.1
    docker tag docker.bintray.io/jfrog/xray-analysis:2.8.9                        ${DEST_TAG}/xray-analysis:2.8.9
    docker tag docker.bintray.io/jfrog/xray-persist:2.8.9                         ${DEST_TAG}/xray-persist:2.8.9
    docker tag docker.bintray.io/jfrog/xray-indexer:2.8.9                         ${DEST_TAG}/xray-indexer:2.8.9
    docker tag docker.bintray.io/jfrog/xray-server:2.8.9                          ${DEST_TAG}/xray-server:2.8.9
    docker tag docker.bintray.io/jfrog/nginx-artifactory-pro:latest               ${DEST_TAG}/nginx-artifactory-pro:latest
    docker tag docker.bintray.io/jfrog/artifactory-pro:latest                     ${DEST_TAG}/artifactory-pro:latest
    docker tag docker.bintray.io/jfrog/insight-server:3.5.3                       ${DEST_TAG}/insight-server:3.5.3
    docker tag docker.bintray.io/jfrog/insight-scheduler:3.5.3                    ${DEST_TAG}/insight-scheduler:3.5.3
    docker tag docker.bintray.io/jfrog/insight-executor:3.5.3                     ${DEST_TAG}/insight-executor:3.5.3
    docker tag docker.bintray.io/jfrog/mission-control:3.5.3                      ${DEST_TAG}/mission-control:3.5.3
    docker tag docker.bintray.io/jfrog/nginx-artifactory-pro:6.9.1                ${DEST_TAG}/nginx-artifactory-pro:6.9.1
    docker tag docker.bintray.io/jfrog/elasticsearch-oss-sg:6.6.0                 ${DEST_TAG}/elasticsearch-oss-sg:6.6.0
    docker tag jfrog-docker-reg2.bintray.io/jfrog/elasticsearch-oss-sg:6.1.1      ${DEST_TAG}/elasticsearch-oss-sg:6.1.1
    docker tag jfrog-docker-reg2.bintray.io/postgres:9.6.11                       ${DEST_TAG}/postgres:9.6.11
    docker tag docker.bintray.io/jfrog/distribution-postgres:9.6.10               ${DEST_TAG}/distribution-postgres:9.6.10
    docker tag docker.bintray.io/jfrog/distribution-redis:4.0.8                   ${DEST_TAG}/distribution-redis:4.0.8
    docker tag docker.bintray.io/jfrog/xray-rabbitmq:3.7.0-management             ${DEST_TAG}/xray-rabbitmq:3.7.0-management
    docker tag docker.bintray.io/jfrog/xray-mongo:3.2.6                           ${DEST_TAG}/xray-mongo:3.2.6
    docker tag docker.bintray.io/jfrog/xray-rabbitmq:3.6.1-management             ${DEST_TAG}/xray-rabbitmq:3.6.1-management
    docker tag docker.bintray.io/jfrog/xray-postgres:9.5.2                        ${DEST_TAG}/xray-postgres:9.5.2
    docker tag bitnami/redis:4.0.11-debian-9                                      ${DEST_TAG}/redis:4.0.11-debian-9 
    docker tag busybox:1.30                                                       ${DEST_TAG}/busybox:1.30  
    
    for jfrog_img in  distribution-installer:1.6.1 distribution-distributor:1.6.1 distribution-distribution:1.6.1 xray-analysis:2.8.9             \
                      xray-persist:2.8.9 xray-indexer:2.8.9 xray-server:2.8.9 nginx-artifactory-pro:latest artifactory-pro:latest                 \
                      insight-server:3.5.3 insight-scheduler:3.5.3 insight-executor:3.5.3 mission-control:3.5.3 nginx-artifactory-pro:6.9.1       \
                      elasticsearch-oss-sg:6.6.0 elasticsearch-oss-sg:6.1.1 postgres:9.6.11 distribution-postgres:9.6.10 distribution-redis:4.0.8 \
                      xray-rabbitmq:3.7.0-management xray-mongo:3.2.6 xray-rabbitmq:3.6.1-management xray-postgres:9.5.2 redis:4.0.11-debian-9    \
                      busybox:1.30
    do
      docker push ${DEST_TAG}/${jfrog_img}        
    done
fi

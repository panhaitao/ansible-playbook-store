#!/bin/bash
## 设置变量
PWD_LOCAL_RUN=$(pwd)
[[ $0 =~ "/" ]] && cd ${0%/*}
PWD_LOCAL=$(pwd)
DOCKER_PATH=/var/lib/docker
REGISTRY_IMAGE="registry:latest"
. function.sh
. /alauda/install_info

## 安装镜像仓库
install_registry()
{
    cat <<EOF >/alauda/.run_up_registry.sh
    docker load -i ${PWD_LOCAL}/registry.tar
    docker run -d \
        --restart=always \
        --name pkg-registry-up \
        -p 60081:5000 \
        -v ${PWD_LOCAL}/registry:/var/lib/registry \
        ${REGISTRY_IMAGE}
EOF
    if bash /alauda/.run_up_registry.sh >/dev/null 2>&1
    then
        log_print init success "install pkg-registry success, alauda registry endpoint 127.0.0.1:60081"
    else
        log_print init error 'install pkg-registry failure, Run /alauda/.run_up_registry.sh script to try to deploy test manually'
        exit 1
    fi
}
install_registry
num=0
chart_num=$(ls ${PWD_LOCAL}/chartmuseum/*.tgz | wc -l)
percent=$((${num}*100/${chart_num}))
str='#'
ch=('|' '\' '-' '/')
index=0
rm -rf /tmp/chart_fail.list
for i in ${PWD_LOCAL}/chartmuseum/*.tgz
do
    if curl --data-binary "@$i" ${CHART_ENDPOINT%/}/api/charts >/dev/null 2>&1
    then
        ((num++))
        percent=$((${num}*100/${chart_num}))
        str=$(seq -s '#' ${percent} | sed 's/[0-9]//g')
        str+='#'
        index=$((${num}%4))
    else
        echo $i >>/tmp/chart_fail.list
    fi
    printf "[%-100s][%d%%][%c]\r" ${str} ${percent} ${ch[$index]}
    sleep 0.1
done
printf "\n"

if [ ${percent} == 100 ]
then
    log_print init success "Upload all chart to ${CHART_ENDPOINT%/} successfully"
else
    log_print init error "Upload chart failed, see /tmp/chart_fail.list file for list of failures"
fi

rm -rf /tmp/images.list
for i in $(curl 127.0.0.1:60081/v2/_catalog?n=500 2>/dev/null | sed -e 's/^.*\[//' -e 's/\].*$//' -e 's/,/\n/g' -e s'/"//g')
do
    for j in $(curl 127.0.0.1:60081/v2/$i/tags/list 2>/dev/null | jq ".tags|keys" | sed -e '1d' -e '$d' -e 's/,//g')
    do
        echo $i:$(curl 127.0.0.1:60081/v2/$i/tags/list 2>/dev/null |jq ".tags[$j]" | sed 's/"//g') >>/tmp/images.list
    done
done
num=0
images_num=$(cat /tmp/images.list | wc -l)
percent=$((${num}*100/${images_num}))
str='#'
index=0
rm -rf /tmp/images_fail.list
for i in $(cat /tmp/images.list)
do
    docker pull 127.0.0.1:60081/$i >/dev/null 2>&1
    docker tag 127.0.0.1:60081/$i 127.0.0.1:60080/$i >/dev/null 2>&1
    if docker push 127.0.0.1:60080/$i >/dev/null 2>&1
    then
        ((num++))
        percent=$((${num}*100/${images_num}))
        str=$(seq -s '#' ${percent} | sed 's/[0-9]//g')
        str+='#'
        index=$((${num}%4))
    else
        echo $i >>/tmp/images_fail.list
    fi
    printf "[%-100s][%d%%][%c]\r" ${str} ${percent} ${ch[$index]}
    docker rmi 127.0.0.1:60081/$i 127.0.0.1:60080/$i >/dev/null 2>&1
done
printf "\n"
if [ ${percent} == 100 ]
then
    log_print init success "Upload all images to 127.0.0.1:60080 successfully"
else
    log_print init error "Upload images failed, see /tmp/images_fail.list file for list of failures"
fi
docker rm -f pkg-registry-up

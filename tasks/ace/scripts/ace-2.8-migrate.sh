#!/bin/bash
if [ ! -f /tmp/function.sh ]
then
    echo 'not find function.sh '
    exit 1
fi
. /tmp/function.sh
check_type=migrate
log_print ${check_type} info 'rebuild jakiro pod, and sleep 40s'
## 删掉 jakiro 的 pod ，重建
kubectl delete po -n alauda-system $( kubectl get po -n alauda-system |grep -w jakiro |awk '{print $1}')
sleep 40
log_print ${check_type} info 'get alauda pods list'
## 获取所有的 alauda-system ns 下的 pod 列表
kubectl get pod -n alauda-system -o wide | sed 1d | awk '{print $1}' >/tmp/pod.list
log_print ${check_type} info 'start migrateion for each alauda component'

## 创建 migrate 列表
cat << EOF >/tmp/migrate.list
architect sh /migrate.sh
chen2 sh /migrate.sh
chen2 sh /sync_public_plugin_repo.sh
chen2 sh /sync_public_repo.sh
darchrow python manage.py migrate
davion python3 manage.py migrate
enigma sh /db-migrate.sh
enigma sh /init-jenkins-template.sh
furion -c furion python manage.py migrate
heimdall sh ./migrate.sh
lightkeeper2 sh /migrate.sh
lightkeeper2 sh /lightkeeper/scripts/create_weblab_json.sh
jakiro python manage.py makemigrations
jakiro python manage.py migrate
lucifer python manage.py migrate
razzil python manage.py migrate
razzil sh /razzil/scripts/loaddate_ci_envs_catalog.sh
tiny python manage.py migrate
morgans python /morgans/migration/api/migrate.py
morgans sh /morgans/migration/db/migrate.sh
EOF
## 开始 migrate
cat /tmp/migrate.list | while read line
do
    migrate_name=${line%% *}
    migrate_command=${line#* }
    sleep 10
    for i in 1 2 3 4 5
    do
        if [ $i == '4' ]
        then
## 执行三次依旧失败，就退出
            log_print ${check_type} error "${migrate_name} migrate has failed three times, the deployment ACE failed"
            exit 1
        fi
        log_print ${check_type} info "start ${migrate_name} migrate, command = ${migrate_command}" >> /alauda/alauda.log
## timeout 最少120 秒，如果部署环境的服务器慢，还需要酌情增加
        if timeout 120 kubectl exec -n alauda-system $(grep "${migrate_name}-[a-z0-9]\{3,\}-[a-z0-9]\{3,\}$" /tmp/pod.list 2>/dev/null | head -n 1) ${migrate_command} >>/alauda/alauda.log 2>&1
        then
            log_print ${check_type} success "${migrate_name} success, migrate command = ${migrate_command}"
            break
        else
            log_print ${check_type} error "${migrate_name} failed, migrate command = ${migrate_command}"
        fi
    done
done

## 为所有的 ns 加标签
for i in `kubectl get ns |awk '{print $1}' |sed 1d`
do
    kubectl label ns $i project.alauda.io/name=system --overwrite
done
log_print ${check_type} info "migrate 的日志在$(hostname) 的/alauda/alauda.log里"

#!/bin/bash

#set -x

# 报警阀值 
DISK=70

# 主机信息 

export LANG=C
export TIME=`date +"%Y-%m-%d"`
export HOSTIP=`hostname -i`
export LOGDIR=$HOME/result/
export ERRLOG=$LOGDIR/$TIME.error.log
export INFOLOG=$LOGDIR/$TIME.k8s.log

# 准备工作

mkdir -p $LOGDIR
> $ERRLOG
> $INFOLOG 

# 检查 etcd 运行状态
	echo "`date` K8s cluster status running in $HOSTIP :" >> $INFOLOG
function check_etcd_stats()
{
	CONTAINER_ID=`docker ps | grep etcd | head -n 1 | awk '{print $1}'`
    docker stats $CONTAINER_ID --no-stream | awk 'NR>1' | while read line
	do
		CPU=`echo $line | awk '{print $2}'`
		MEM=`echo $line | awk '{print $6}'`
		BLOCK_IO=`echo $line | awk '{print $10 $11 $12}'`
		echo "         CPU use is      : $CPU" >> $INFOLOG 
		echo "         MEM use is      : $MEM" >> $INFOLOG 
		echo "         BLOCK_IO use is : $BLOCK_IO" >> $INFOLOG 
	done
}

# 检查 k8s 集群状态
function check_k8s_cluster()
{ 
	echo "K8s master status :" >> $INFOLOG
	kubectl get cs  |  awk 'NR>1 {print $1" "$2" "$3" "$4}' | while read line
	do
		NAME=`echo $line | awk '{print $1}'`
		STATUS=`echo $line | awk '{print $2}'`
		MESSAGE=`echo $line | awk '{print $3}'`
		ERROR=`echo $line | awk '{print $4}'`
		if [[ "$STATUS" == "Healthy" ]];then
			echo "        $NAME is ok " >> $INFOLOG
		else
			echo "        k8s master node $HOSTIP $NAME is $MESSAGE " >> $ERRLOG
		fi
	done 
}


# 检查pod 是否可以 exec 
function check_pod_exec()
{
	echo "`date` k8s pod exec status Running in $HOSTIP:" >> $INFOLOG
    kubectl get pods --all-namespaces | awk 'NR>1 {print $1" "$2}' | while read line
	do
		NS=`echo $line | awk '{print $1}' `
		POD=`echo $line | awk '{print $2}' `
		kubectl exec $POD -n $NS date
		if [[ "$?" == "0" ]];then
			echo "        $POD of $NS exec check is ok" >> $INFOLOG
		else
			echo "        $POD of $NS exec check is failed" >> $INFOLOG
			echo "        $POD of $NS exec check is failed" >> $ERRLOG
		fi	
	done	
}

# 删除处于Terminating 状态5分钟以上的POD
function delete_pod()
{
	kubectl get pods --all-namespaces | grep -i Terminating | awk '{ print $1" "$2" "$6}' | while read line
	do
		ns=`echo $line | awk '{print $1}'` 
	  	pod=`echo $line | awk '{print $2}'`
		podtime=`echo $line | awk '{print $3}'`

	    if [[ "${podtime}" =~ h$ ]];then
			kubectl delete pod $pod -n $ns --force --grace-period=0
			echo " `date` Pod $pod of $ns is deleted" >> $K8SLOG
		elif [[ "${podtime}" =~ d$ ]];then
			kubectl delete pod $pod -n $ns --force --grace-period=0
			echo " `date` Pod $pod of $ns is deleted" >> $K8SLOG
		elif [[ "${podtime}" =~ m$ ]];then
			pod_num=`echo ${podtime} | awk -F"m" '{print $1}'`
			let num=$pod_num+0
		    if [[ $num -ge 5 ]];then
				kubectl delete pod $pod -n $ns --force --grace-period=0
			    echo " `date` Pod $pod of $ns is deleted" >> $K8SLOG
			fi
		fi
	done
}

check_etcd_stats
check_k8s_cluster
check_pod_exec
delete_pod

##### 查看系统告警信息

echo "Error info:"
cat $ERRLOG
echo "Log info:"
cat $INFOLOG 

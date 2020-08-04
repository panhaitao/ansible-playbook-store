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
export INFOLOG=$LOGDIR/$TIME.info.log

# 准备工作

mkdir -p $LOGDIR
> $ERRLOG
> $INFOLOG 

###########判断主机磁盘##############

 echo "`hostname` $HOSTIP `date` system sattus check result:" >> $INFOLOG
function check_system_load()
{
	LOAD_STD=`nproc`
	LOAD_1=`uptime | awk -F"load average" '{print $2}' | awk -F, '{print $1'}`
	LOAD_5=`uptime | awk -F"load average" '{print $2}' | awk -F, '{print $2'}`
	LOAD_15=`uptime | awk -F"load average" '{print $2}' | awk -F, '{print $3'}`

	echo $LOAD_1  $LOAD_STD | awk '{ if($1>$2) {printf" system last 1min  load average %f is over cpu core number: %.0f\n",$1,$2} }'
	echo $LOAD_5  $LOAD_STD | awk '{ if($1>$2) {printf" system last 5min  load average %f is over cpu core number: %.0f\n",$1,$2} }'
	echo $LOAD_15 $LOAD_STD | awk '{ if($1>$2) {printf" system last 15min  load average %f is over cpu core number: %.0f\n",$1,$2} }'

    echo "System Load aveage :" >> $INFOLOG
    echo "        Last 1 min Load average is  : $LOAD_1" >> $INFOLOG 
    echo "        Last 5 min Load average is  : $LOAD_5" >> $INFOLOG 
    echo "        Last 15 min Load average is : $LOAD_15" >> $INFOLOG 
}

function check_mem_use_percent()
{
	mem_total=`free -m | grep Mem | awk '{print $2}'`
	mem_used=`free -m | grep Mem | awk '{print $3}'`
	percent=`awk -v total=$mem_total -v used=$mem_used 'BEGIN {printf "%.0f\n",used/total*100}'`

    echo "System mem stat of $HOSTIP :" >> $INFOLOG
    echo "        System mem used percent is : ${percent}%:" >> $INFOLOG
	echo $percent 80 | awk '{ if($1>=$2) {printf" system free mem percent is  %.0f/100 less than: %.0f/100 \n",$1,$2} }'
}

function check_disk_use_percent()
{

	echo "disk used stats:" >> $INFOLOG
	df -h  |  awk 'NR>1 { print $5" "$6 }' | while read line
	do
	    part_use=`echo $line | awk '{print $1}' | awk -F% '{print $1}'`
	    part_mount=`echo $line | awk '{print $2}'`
	    
	    if [[ "${part_mount}" == "/"  ]];then
	    	echo "       System $part_mount Usage is  $part_use %  " >> $INFOLOG
	    fi
	    
	    if [[ ${part_use} -ge 70 ]];then
	    	echo "       Local Dir $part_mount Usage is over $part_use %  " >> $ERRLOG
	    fi
	    
	    if [[ ${part_use} -ge 70 && "${part_mount}" == "/var"  ]];then
	    	echo "       Container Datadir /var/lib/docker is over $part_use %" >> $ERRLOG
	    fi
	done
}

function check_lvm_stats()
{
	echo "lvm status  :" >> $INFOLOG
	lvs -o+seg_monitor |  awk 'NR>1 {print $4" "$5" "$6" "$7}' | while read line
	do
		LSize=`echo $line | awk '{print $1}'`
		DataPercent=`echo $line | awk '{print $2}'`
		MetaPercent=`echo $line | awk '{print $3}'`
		Monitor=`echo $line | awk '{print $4}'`
		echo "         thinpool LSize :       is  $LSize" >> $INFOLOG 
		echo "         thinpool Data% :       is  $DataPercent" >> $INFOLOG 
		echo "         thinpool Meta% :       is  $MetaPercent" >> $INFOLOG 
		echo "         thinpool Montor stat : is  $Monitor" >> $INFOLOG 
	done

	tail -n 100 /var/log/messages | grep -i "error: devmapper" &> /dev/null
	if [[ "$?" == "0" ]];then
		echo "         `hostname`($HOSTIP): lvm devmapper is problem" >> $INFOLOG 
	fi
}

function check_service_all()
{

	echo "checck core services statu :" >> $INFOLOG
	for srv in docker kubelet sshd
	do
	    stat=`systemctl status $srv | head -n 3 | awk 'NR>2 {print $3}'`
		echo "           $srv statu is : $stat " >> $INFOLOG 
	done
}

function check_io_status()
{
	echo "check io statu :" >> $INFOLOG
	iostat | awk 'NR>6 {print $1" "$2" "$3" "$4}' | sed '$d' | while read line
	do
		device=`echo $line | awk '{print $1}'`
		tps=`echo $line | awk '{print $2}'`
		kb_read_s=`echo $line | awk '{print $3}'`
		kb_wrtn_s=`echo $line | awk '{print $4}'`
		echo -e `date +%F-%H:%M:%S` `hostname`\($HOSTIP\) DiskIO statu: device:$device	tps:$tps	Kb_read/s:$kb_read_s	Kb_wrtn/s:$kb_wrtn_s >> $INFOLOG
	done
}

function check_netio_status()
{
	echo "check NetIO statu :" >> $INFOLOG
    ifstat | grep -E 'eth|enp' | awk '{print $1" "$6" "$8}' | while read line
	do
		interface=`echo $line | awk '{print $1}'`
		rx_data_rate=`echo $line | awk '{print $2}'`
		tx_data_rate=`echo $line | awk '{print $3}'`
		echo -e `date +%F-%H:%M:%S` `hostname`\($HOSTIP\) NetIO statu: interface: $interface	RX_Data/Rate:$rx_data_rate	TX_Data/Rate: $tx_data_rate >> $INFOLOG
	done
}

##### 查看系统告警信息

check_system_load 
check_mem_use_percent
check_disk_use_percent
check_lvm_stats 
check_service_all
check_io_status
check_netio_status

#### 显示结果

cat $ERRLOG
cat $INFOLOG

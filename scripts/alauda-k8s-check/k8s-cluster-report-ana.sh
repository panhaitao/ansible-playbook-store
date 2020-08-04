#!/bin/bash

set -x

export logfile=$1
export report_log=report/$2

mkdir -pv report/
touch ${report_log}
> ${report_log}

function do_report()
{
	export match_str=$1
	result=`cat $logfile | grep -v \"stdout\" | grep $match_str` >> $report_log

}

echo "system load status" >> $report_log
cat $logfile | grep -v \"stdout\" | grep "Last 1 min Load average" | sort | uniq >> $report_log
cat $logfile | grep -v \"stdout\" | grep "Last 5 min Load average" | sort | uniq >> $report_log 
cat $logfile | grep -v \"stdout\" | grep "Last 15 min Load average" | sort | uniq >> $report_log 
cat $logfile | grep -v \"stdout\" | grep "System mem used" | sort | uniq >> $report_log 
cat $logfile | grep -v \"stdout\" | grep "System / Usage" | sort | uniq >> $report_log 

echo "ETCD load status" >> $report_log
cat $logfile | grep -v \"stdout\" | grep "CPU" | sort | uniq >> $report_log
cat $logfile | grep -v \"stdout\" | grep "MEM" | sort | uniq >> $report_log
cat $logfile | grep -v \"stdout\" | grep "BLOCK_IO" | sort | uniq >> $report_log  

echo "K8S cluster status" >> $report_log
cat $logfile | grep -v \"stdout\" | grep "controller-manager" | sort | uniq >> $report_log 
cat $logfile | grep -v \"stdout\" | grep "scheduler" | sort | uniq >> $report_log 
cat $logfile | grep -v \"stdout\" | grep "etcd" | sort | uniq >> $report_log 

echo "LVM status" >> $report_log
cat $logfile | grep -v \"stdout\" | grep "thinpool Montor stat" | sort | uniq >> $report_log 
cat $logfile | grep -v \"stdout\" | grep "thinpool Data"  | sort | uniq >> $report_log 
cat $logfile | grep -v \"stdout\" | grep "thinpool Meta"  | sort | uniq >> $report_log 
cat $logfile | grep -v \"stdout\" | grep "lvm devmapper"  | sort | uniq >> $report_log 

echo "SEVIES status" $report_log
cat $logfile | grep -v \"stdout\" | grep "docker statu" | sort | uniq >> $report_log 
cat $logfile | grep -v \"stdout\" | grep "kubelet statu" | sort | uniq >>  $report_log 
cat $logfile | grep -v \"stdout\" | grep "nfs statu" | sort | uniq >>  $report_log 

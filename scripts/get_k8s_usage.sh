#!/bin/bash

cpu_limits_total=0
cpu_requests_total=0
mem_limits_total=0
mem_requests_total=0

function deal_format()
{
	tmpfile=/tmp/$$
	touch $tmpfile
	local item=$1

	if [[ "$item" == "" ]];then
		echo ""
	else
		type=`echo ${item: -1}`
		if [[ "$type" == "m" ]]; then
			size=`echo $item | awk -F$type '{print $1}'`
			result=$( echo "scale=4; $size/1000" | bc )
			echo $result > $tmpfile
		elif [[ "$type" == "M" ]]; then
			size=`echo $item | awk -F$type '{print $1}'`
			result=$( echo "scale=4; $size/1000" | bc )
			echo $result > $tmpfile
		else
			type=`echo ${item: -2}`
		
			if [[ "$type" == "Mi" ]]; then
				size=`echo $item | awk -F$type '{print $1}'`
				result=$( echo "scale=4; $size/1024" | bc )
				echo $result > $tmpfile
			else
				size=$item
				result=$( echo "scale=4; $size/1" | bc )
				echo $result > $tmpfile
			
			fi
		fi
	result=`cat $tmpfile`
	echo $result
	fi
}
kubectl get pods --all-namespaces | grep -E 'default|kube-system|kube-publick' | awk '{print $1"\t"$2}' | while read line
do
	ns=$( echo $line | awk '{print $1}' )
	pod=$( echo $line | awk '{print $1}' )

	cpu_limits=$( kubectl get pods -n $ns $pod -o=jsonpath='{.spec.containers[0]}.resources.limits.cpu}' )
	cpu_requests=$( kubectl get pods -n $ns $pod -o=jsonpath='{.spec.containers[0]}.resources.requests.cpu}' )

	mem_limits=$( kubectl get pods -n $ns $pod -o=jsonpath='{.spec.containers[0]}.resources.limits.memory}' )
	mem_requests=$( kubectl get pods -n $ns $pod -o=jsonpath='{.spec.containers[0]}.resources.requests.memory}' )

	cpu_limits_size=`deal_format $cpu_limits`
	cpu_request_size=`deal_format $cpu_request`
	mem_limits_size=`deal_format $mem_limits`
	mem_request_size=`deal_format $mem_requests`

	[[ "$cpu_limits_size" != "" ]] && cpu_limits_total=$( echo "scale=4; $cpu_limits_total+$cpu_limits_size" | bc )
	[[ "$cpu_requests_size" != "" ]] && cpu_requests_total=$( echo "scale=4; $cpu_requests_total+$cpu_requests_size" | bc )
	[[ "$mem_limits_size" != "" ]] && mem_limits_total=$( echo "scale=4; $mem_limits_total+$mem_limits_size" | bc )
	[[ "$mem_requests_size" != "" ]] && mem_requests_total=$( echo "scale=4; $mem_requests_total+$mem_requests_size" | bc )

	echo "cpu_limits_total: $cpu_limits_total cpu_requests_total: $cpu_requests_total mem_limits_total: $mem_limits_total mem_requests_total: $mem_requests_total" > /tmp/log
done

cat /tmp/log

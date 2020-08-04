#!/bin/sh

> /tmp/ns_pod
mkdir -pv /tmp/result/

kubectl get pods --all-namespaces | awk 'NR>1 {print $1 "\t" $2}' &> /tmp/ns_pod

while read line
	do
		ns=`echo $line | awk '{print $1}'`
		pod=`echo $line | awk '{print $2}'`
	        > /tmp/result/$ns-$pod 	
		echo $ns $pod >> /tmp/result/$ns-$pod 	
		kubectl get pods $pod -n $ns -o jsonpath="{.spec.containers[*].env[*]}" | tr ' ' '\n\r' | sort | uniq >> /tmp/result/$ns-$pod 	
done < /tmp/ns_pod

function show_pod()
{

cd /tmp/result
grep -ir cpaas.cebbank *

> /tmp/ns_pod
mkdir -pv /tmp/result/

kubectl get pods --all-namespaces | awk 'NR>1 {print $1 "\t" $2}' &> /tmp/ns_pod

while read line
	do
		ns=`echo $line | awk '{print $1}'`
		pod=`echo $line | awk '{print $2}'`
	        > /tmp/result/$ns-$pod 	
		echo $ns $pod >> /tmp/result/$ns-$pod 	
		kubectl get pods $pod -n $ns -o yaml >> /tmp/result/$ns-$pod 	
done < /tmp/ns_pod
}

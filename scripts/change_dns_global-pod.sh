#!/bin/bash

kubectl get pods --all-namespaces | awk 'NR>1 {print $1 "\t" $2}' &> /tmp/ns_pod
for pod in coredns jakiro jakiro2 lucifer architect chen2 darchrow davion enigma furion enigma heimdall lightkeeper nevermore tiny razzli rubick vision  windranger
do
    grep -ir $pod /tmp/ns_pod  >> /tmp/old_pod
done

while read line
do
    ns=`echo $line | awk '{print $1}'`  
    pod=`echo $line | awk '{print $2}'`
    echo "$ns $pod will be deleted"  
    kubectl delete pod $pod -n $ns
done < /tmp/ns_pod


##### restart all alauda system pod 
a=`kubectl get pods -n alauda-system | awk 'NR>1 {print $1}'`
kubectl delete pod $a[*] -n alauda-system

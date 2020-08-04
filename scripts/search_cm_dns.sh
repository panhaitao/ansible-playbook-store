#!/bin/sh

> /tmp/ns_cm
rm -rvf /tmp/result/
mkdir -pv /tmp/result/

kubectl get cm --all-namespaces | awk 'NR>1 {print $1 "\t" $2}' &> /tmp/ns_cm

while read line
        do
                ns=`echo $line | awk '{print $1}'`
                cm=`echo $line | awk '{print $2}'`
                > /tmp/result/$ns-$cm
                echo $ns $cm >> /tmp/result/$ns-$cm 
                kubectl get cm $cm -n $ns -o yaml >> /tmp/result/$ns-$cm
done < /tmp/ns_cm

cd /tmp/result
grep -ir cpaas.cebbank * | awk -F: '{print $1}' | sort | uniq 




kubectl get deploy --all-namespaces | awk 'NR>1 {print $1 "\t" $2}' &> /tmp/ns_dp

while read line
        do
                ns=`echo $line | awk '{print $1}'`
                dp=`echo $line | awk '{print $2}'`
                > /tmp/result/$ns-$dp
                echo $ns $dp >> /tmp/result/$ns-$dp 
                kubectl get deploy $dp -n $ns -o yaml >> /tmp/result/$ns-$dp
done < /tmp/ns_dp

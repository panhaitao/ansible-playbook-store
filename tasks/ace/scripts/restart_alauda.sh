#!/bin/sh
a=`kubectl get pods -n alauda-system | awk 'NR>1 {print $1}'`
kubectl delete pod ${a[*]} -n alauda-system

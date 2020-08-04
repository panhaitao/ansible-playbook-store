#!/bin/sh
for f in `kubectl get pods  --all-namespaces | grep rubick | awk '{print $2}'`
do
    kubectl delete pod $f -n alauda-system
done

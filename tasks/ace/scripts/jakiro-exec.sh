#!/bin/bash
set -x
ns=`kubectl get pods --all-namespaces | grep jakiro  | head -n1 | awk '{print $1}'`
pod=`kubectl get pods --all-namespaces | grep jakiro  | head -n1 | awk '{print $2}'`
kubectl exec -t  -i -n $ns $pod  -- sh -c "python manage.py syncroles -o cpaas"

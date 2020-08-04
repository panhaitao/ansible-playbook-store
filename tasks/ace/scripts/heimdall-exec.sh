#!/bin/bash
set -x
ns=`kubectl get pods --all-namespaces | grep heimdall  | head -n1 | awk '{print $1}'`
pod=`kubectl get pods --all-namespaces | grep heimdall  | head -n1 | awk '{print $2}'`
kubectl exec -t  -i -n $ns $pod  -- sh -c "curl -v -X PUT http://localhost:80/v3/schemas/convert_schema/view_action"
kubectl exec -t  -i -n $ns $pod  -- sh -c "curl -v -X PUT http://localhost:80/v3/roles/convert_template/view_action"
kubectl exec -t  -i -n $ns $pod  -- sh -c "curl -v -X PUT http://localhost:80/v3/roles/convert_roles/view_action"

#!/bin/bash
ns=$1
for pod in `kubectl get pods -n $ns | awk '{print $1}'`
do
    kubectl exec -t  -i -n $ns $pod  -- sh -c "netstat | grep 11.11.157.138"  &> /dev/null
    if [[ "$?" == "0" ]];then
      #kubectl delete pods $pod -n $ns
      echo " ### $pod ### "
    fi
done

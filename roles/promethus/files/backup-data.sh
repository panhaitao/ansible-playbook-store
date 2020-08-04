#!/bin/bash

mkdir -pv /alauda/monitor-data-bak/

if [ -d "/var/lib/monitoring/" ]; then
    rsync -av /var/lib/monitoring/  /alauda/monitor-data-bak/monitor-data-bak_`date '+%Y%m%d_%H.%M.%S'`
    kubectl get prometheusrules --all-namespaces -o yaml > /alauda/monitor-data-bak/prometheusrules_`date '+%Y%m%d_%H.%M.%S'`
fi

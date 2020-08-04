#!/bin/sh
curl -v -X PUT -u {{ master_auth }} http://{{ master_ip }}:32001/v2/kubernetes/clusters/global/update_label

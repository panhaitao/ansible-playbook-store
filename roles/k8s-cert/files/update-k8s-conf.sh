#!/bin/bash

mv /etc/kubernetes/*.conf /root/ -f
cd /etc/kubernetes/
kubeadm init phase kubeconfig all --config=/etc/kubeadmin/kubeadmcfg.yaml

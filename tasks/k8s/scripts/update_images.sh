#!/bin/sh
sed -i 's/1.13.4/1.13.10/' /etc/kubernetes/manifests/kube-controller-manager.yaml
sed -i 's/1.13.4/1.13.10/' /etc/kubernetes/manifests/kube-scheduler.yaml
sed -i 's/1.13.4/1.13.10/' /etc/kubernetes/manifests/kube-apiserver.yaml

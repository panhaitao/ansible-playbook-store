kubectl get pod -n kube-system |grep proxy |awk '{print $1}'|xargs kubectl delete pod -n kube-system
kubectl get pod -n kube-system |grep dns |awk '{print $1}'|xargs kubectl delete pod -n kube-system

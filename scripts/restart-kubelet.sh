
a=`kubectl get pods -n kube-system| grep coredns | awk '{print $1}'`;kubectl delete pod ${a[*]} -n kube-system
a=`kubectl get pods -n alauda-system | awk 'NR>1 {print $1}'`;kubectl delete pod ${a[*]} -n alauda-system



sed -i 's/gk8s-bs.cebbank.com/gk8s.bs.io/' /etc/systemd/system/kubelet.service && systemctl daemon-reload && systemctl restart kubelet
sed -i 's/gk8s-bs.cebbank.com/sck8s.bs.io/' /etc/systemd/system/kubelet.service && systemctl daemon-reload && systemctl restart kubelet



## gk8s.td.io

   #  gk8s.td.io
   #  global-mysql.td.io
#  cpaas- -n kube-systemd.cebbank.com -> td.io

echo "nameserver      10.213.111.241" >  /etc/resolv.conf;
sed -i 's/gk8s-td.cebbank.com/gk8s.td.io/' /etc/systemd/system/kubelet.service && systemctl daemon-reload && systemctl restart kubelet
echo "10.213.110.1 gregistry.cpaas-td.cebbank.com" >> /etc/hosts

kubectl edit deployments jakiro -n alauda-system                     
kubectl edit deployments gk8s-regisrty -n alauda-system
kubectl edit cm global-var -n alauda-system
kubectl edit cm cluster-configmap -n default
kubectl edit cm coredns -n kube-system


a=`kubectl get pods -n default| grep nevermore | awk '{print $1}'`;kubectl delete pod ${a[*]} -n default

a=`kubectl get pods -n kube-system| grep coredns | awk '{print $1}'`;kubectl delete pod ${a[*]} -n kube-system
a=`kubectl get pods -n alauda-system | awk 'NR>1 {print $1}'`;kubectl delete pod ${a[*]} -n alauda-system


## cck8s.td.io

   #  cck8s.td.io
   #  global-mysql.td.io
#  cck8s-td.cebbank.com -> cck8s.td.io

echo "nameserver      10.213.111.241" >  /etc/resolv.conf;
sed -i 's/cck8s-td.cebbank.com/cck8s.td.io/' /etc/systemd/system/kubelet.service && systemctl daemon-reload && systemctl restart kubelet
echo "10.213.110.1 gregistry.cpaas-td.cebbank.com" >> /etc/hosts

kubectl edit cm ake-config -n kube-system
kubectl edit cm cluster-configmap -n default
kubectl edit cm coredns -n kube-system

a=`kubectl get pods -n default| grep nevermore | awk '{print $1}'`
kubectl delete pod ${a[*]} -n default

a=`kubectl get pods -n kube-system| grep coredns | awk '{print $1}'`
kubectl delete pod ${a[*]} -n kube-system

a=`kubectl get pods -n alauda-system | awk 'NR>1 {print $1}'`
kubectl delete pod ${a[*]} -n alauda-system


## devk8s.td.io

   #  devk8s.td.io
   #  global-mysql.td.io
#  cck8s-td.cebbank.com -> devk8s.td.io

echo "nameserver      10.213.111.241" >  /etc/resolv.conf;
sed -i 's/devk8s-td.cebbank.com/devk8s.td.io/' /etc/systemd/system/kubelet.service && systemctl daemon-reload && systemctl restart kubelet
echo "10.213.110.1 gregistry.cpaas-td.cebbank.com" >> /etc/hosts

kubectl edit cm ake-config -n kube-system
kubectl edit cm cluster-configmap -n default
kubectl edit cm coredns -n kube-system

a=`kubectl get pods -n default| grep nevermore | awk '{print $1}'`
kubectl delete pod ${a[*]} -n default

a=`kubectl get pods -n kube-system| grep coredns | awk '{print $1}'`
kubectl delete pod ${a[*]} -n kube-system

a=`kubectl get pods -n alauda-system | awk 'NR>1 {print $1}' | grep -v jenkins`
kubectl delete pod ${a[*]} -n alauda-system --force --grace-period=0

a=`kubectl get pods  --all-namespaces | grep -v Running | awk 'NR>1 {print $2}'`
kubectl delete pod ${a[*]} -n alauda-system

a=`kubectl get pods  --all-namespaces | grep  0/1 | awk 'NR>1 {print $2}'`
kubectl delete pod ${a[*]} -n alauda-system

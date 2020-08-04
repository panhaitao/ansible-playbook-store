#!/bin/bash

#apiserver-etcd-client.crt证书更新步骤如下：

cat <<EOF>apiserver_etcd_client.conf
[ v3_ca ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth,TLS Web Server Authentication, TLS Web Client Authentication
EOF

#openssl genrsa -out apiserver-etcd-client.key 2048
openssl req -new -key /etc/kubernetes/pki/apiserver-etcd-client.key -out apiserver-etcd-client.csr -subj "/O=system:masters/CN=kube-apiserver-etcd-client"
openssl x509 -req -in apiserver-etcd-client.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -sha256 -out apiserver-etcd-client.crt -extensions v3_ca -extfile apiserver_etcd_client.conf -days 3650
mv /etc/kubernetes/pki/apiserver-etcd-client.crt /tmp
cp apiserver-etcd-client.crt /etc/kubernetes/pki/


#更换apiserver证书
cat <<EOF>ssl.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
keyUsage =critical, digitalSignature, keyEncipherment
extendedKeyUsage = TLS Web Server Authentication, TLS Web Client Authentication
subjectAltName = @alt_names
[alt_names]
EOF
ip=1
dns=1
for aa in `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text |grep "DNS"|sed "s/,/\n/g"|grep "DNS"|tr -d " "`; do echo $aa| sed "s/DNS:/DNS.$dns = /" >> ssl.conf;let dns+=1; done
for aa in `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text |grep "IP Address"|sed "s/,/\n/g"|grep "IP Address"|tr -d " " `;do echo $aa| sed "s/IPAddress:/IP.$ip = /" >> ssl.conf;let ip+=1; done
openssl req -new -key /etc/kubernetes/pki/apiserver.key -out apiserver.csr -subj "/CN=kube-apiserver" -config ssl.conf
openssl x509 -req -in apiserver.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out apiserver.crt -days 10950 -extensions v3_req -extfile ssl.conf
mv /etc/kubernetes/pki/apiserver.crt /tmp
cp apiserver.crt /etc/kubernetes/pki/
 
#更换apiserver-kubelet-client证书
cat <<EOF>client.conf
 [ v3_ca ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
EOF
 
 
openssl genrsa -out admin.key 2048
openssl req -new -key admin.key -out admin.csr -subj "/O=system:masters/CN=kube-apiserver-kubelet-client"
openssl x509 -req -in admin.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -sha256 -out admin.crt -extensions v3_ca -extfile client.conf -days 3650
mv /etc/kubernetes/pki/apiserver-kubelet-client.key /tmp
mv /etc/kubernetes/pki/apiserver-kubelet-client.crt /tmp
mv admin.key apiserver-kubelet-client.key
mv admin.crt apiserver-kubelet-client.crt
cp apiserver-kubelet-client.key /etc/kubernetes/pki/
cp apiserver-kubelet-client.crt /etc/kubernetes/pki/
kubectl delete pod -n kube-system kube-apiserver-$HOSTNAME
docker ps |grep "kube-apiserver" | awk '{print $1}' | xargs docker rm -f
 
 
#更换front-proxy-client证书
openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr -subj "/O=system:masters/CN=front-proxy-client"
openssl x509 -req -in client.csr -CA /etc/kubernetes/pki/front-proxy-ca.crt -CAkey /etc/kubernetes/pki/front-proxy-ca.key -CAcreateserial -sha256 -out client.crt -extensions v3_ca -extfile client.conf -days 3650
mv /etc/kubernetes/pki/front-proxy-client.key /tmp
mv /etc/kubernetes/pki/front-proxy-client.crt /tmp
mv client.key front-proxy-client.key
mv client.crt front-proxy-client.crt
cp front-proxy-client.key /etc/kubernetes/pki/
cp front-proxy-client.crt /etc/kubernetes/pki/
sleep 8
 
 
#更换Kubelet证书
#Master节点直接执行此脚本
cat <<EOF>kube.conf
 [ v3_ca ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
EOF
 
 
openssl genrsa -out kubelet.key 2048
openssl req -new -key kubelet.key -out kubelet.csr -subj "/O=system:nodes/CN=system:node:$HOSTNAME"
openssl x509 -req -in kubelet.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -sha256 -out kubelet.crt -extensions v3_ca -extfile kube.conf -days 3650
base64 kubelet.crt | tr -d '\n' > kubelet-crt-data
base64 kubelet.key | tr -d '\n' > kubelet-key-data
KUBELET_CRT_DATA=$(cat kubelet-crt-data)
KUBELET_KEY_DATA=$(cat kubelet-key-data)
sed -i \
-e 's/client-certifica..*:.*/'"client-certificate-data: $KUBELET_CRT_DATA"'/' \
-e 's/client-k..*:.*/'"client-key-data: $KUBELET_KEY_DATA"'/' \
    /etc/kubernetes/kubelet.conf
 
#controller证书更换
openssl genrsa -out controller.key 2048
openssl req -new -key controller.key -out controller.csr -subj "/CN=system:kube-controller-manager"
openssl x509 -req -in controller.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -sha256 -out controller.crt -extensions v3_ca -extfile client.conf -days 3650
base64 controller.crt | tr -d '\n' > controller-crt-data
base64 controller.key | tr -d '\n' > controller-key-data
 
CONTROLLER_CRT_DATA=$(cat controller-crt-data)
CONTROLLER_KEY_DATA=$(cat controller-key-data)
sed -i \
-e 's/client-certifica..*:.*/'"client-certificate-data: $CONTROLLER_CRT_DATA"'/' \
-e 's/client-k..*:.*/'"client-key-data: $CONTROLLER_KEY_DATA"'/' \
    /etc/kubernetes/controller-manager.conf
kubectl delete pod -n kube-system kube-controller-manager-$HOSTNAME
docker ps |grep "k8s_kube-controller-manager" |awk '{print $1}' | xargs docker rm -f
 
#scheduler证书更换
openssl genrsa -out scheduler.key 2048
openssl req -new -key scheduler.key -out scheduler.csr -subj "/CN=system:kube-scheduler"
openssl x509 -req -in scheduler.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -sha256 -out scheduler.crt -extensions v3_ca -extfile client.conf -days 3650
base64 scheduler.crt | tr -d '\n' > scheduler-crt-data
base64 scheduler.key | tr -d '\n' > scheduler-key-data
 
SCHEDULER_CRT_DATA=$(cat scheduler-crt-data)
SCHEDULER_KEY_DATA=$(cat scheduler-key-data)
sed -i \
-e 's/client-certifica..*:.*/'"client-certificate-data: $SCHEDULER_CRT_DATA"'/' \
-e 's/client-k..*:.*/'"client-key-data: $SCHEDULER_KEY_DATA"'/' \
    /etc/kubernetes/scheduler.conf
kubectl delete pod -n kube-system kube-scheduler-$HOSTNAME
docker ps |grep "k8s_kube-scheduler" |awk '{print $1}' | xargs docker rm -f
 
 
systemctl restart kubelet
 
echo -e "\033[5;33;40m master单节点证书签发成功\033[0m \n"
 
echo -e "\033[5;33;40m 验证证书，请仔细查看证书签发时间\033[0m \n"
echo "--------------------------------"
echo "apiserver证书"
echo `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -dates`
echo "--------------------------------"
echo "kubelet证书"
cat /etc/kubernetes/kubelet.conf |grep client-certificate-data |awk -F: '{print $2}' | awk '{print $1}' | base64 -d > a.crt
echo `openssl x509 -in a.crt -noout -dates`
echo "--------------------------------"
echo "controller-manager证书"
cat /etc/kubernetes/controller-manager.conf |grep client-certificate-data |awk -F: '{print $2}' | awk '{print $1}' | base64 -d > a.crt
echo `openssl x509 -in a.crt -noout -dates`
echo "--------------------------------"
echo "scheduler证书"
cat /etc/kubernetes/scheduler.conf |grep client-certificate-data |awk -F: '{print $2}' | awk '{print $1}' | base64 -d > a.crt
echo `openssl x509 -in a.crt -noout -dates`
echo "--------------------------------"
echo "apiserver-kubelet-client证书"
echo `openssl x509 -in /etc/kubernetes/pki/apiserver-kubelet-client.crt -noout -dates`
echo "--------------------------------"
echo "front-proxy-client证书"
echo `openssl x509 -in /etc/kubernetes/pki/front-proxy-client.crt -noout -dates`
rm -rf a.crt

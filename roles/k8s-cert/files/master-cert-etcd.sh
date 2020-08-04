#!/bin/bash
 
#etcd的healthcheck-client-client证书更换
cat <<EOF>healthcheck.conf
 [ v3_ca ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth,TLS Web Server Authentication, TLS Web Client Authentication
EOF
 
 
#openssl genrsa -out healthcheck-client.key 2048
openssl req -new -key /etc/kubernetes/pki/etcd/healthcheck-client.key -out healthcheck-client.csr -subj "/O=system:masters/CN=kube-etcd-healthcheck-client"
openssl x509 -req -in healthcheck-client.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -sha256 -out healthcheck-client.crt -extensions v3_ca -extfile healthcheck.conf -days 3650
mv /etc/kubernetes/pki/etcd/healthcheck-client.crt /tmp
cp healthcheck-client.crt /etc/kubernetes/pki/etcd/
 
 
 
 
#etcd的peer证书更换
 
cat <<EOF>peer-ssl.conf
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
ippeer=1
dnspeer=1
for bb in `openssl x509 -in /etc/kubernetes/pki/etcd/peer.crt -noout -text |grep "DNS"|sed "s/,/\n/g"|grep "DNS"|tr -d " "`; do echo $bb| sed "s/DNS:/DNS.$dnspeer = /" >> peer-ssl.conf;let dnspeer+=1; done
for bb in `openssl x509 -in /etc/kubernetes/pki/etcd/peer.crt -noout -text |grep "IP Address"|sed "s/,/\n/g"|grep "IP Address"|tr -d " " `;do echo $bb| sed "s/IPAddress:/IP.$ippeer = /" >> peer-ssl.conf;let ippeer+=1; done
openssl req -new -key /etc/kubernetes/pki/etcd/peer.key -out peer.csr -subj "/CN=$HOSTNAME" -config peer-ssl.conf
openssl x509 -req -in peer.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out peer.crt -days 3650 -extensions v3_req -extfile peer-ssl.conf
mv /etc/kubernetes/pki/etcd/peer.crt /tmp
cp peer.crt /etc/kubernetes/pki/etcd
 
 
#etcd的server证书更换
cat <<EOF>server-ssl.conf
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
ipserver=1
dnsserver=1
for cc in `openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -noout -text |grep "DNS"|sed "s/,/\n/g"|grep "DNS"|tr -d " "`; do echo $cc| sed "s/DNS:/DNS.$dnsserver = /" >> server-ssl.conf;let dnsserver+=1; done
for cc in `openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -noout -text |grep "IP Address"|sed "s/,/\n/g"|grep "IP Address"|tr -d " " `;do echo $cc| sed "s/IPAddress:/IP.$ipserver = /" >> server-ssl.conf;let ipserver+=1; done
openssl req -new -key /etc/kubernetes/pki/etcd/server.key -out server.csr -subj "/CN=$HOSTNAME" -config server-ssl.conf
openssl x509 -req -in server.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out server.crt -days 3650 -extensions v3_req -extfile server-ssl.conf
mv /etc/kubernetes/pki/etcd/server.crt /tmp
cp server.crt /etc/kubernetes/pki/etcd
kubectl delete pod -n kube-system etcd-$HOSTNAME
docker ps |grep etcd | awk '{print $1}' | xargs docker rm -f
sleep 2
 
 
echo -e "\033[5;33;40m master单节点etcd证书签发成功\033[0m \n"
 
echo -e "\033[5;33;40m 验证证书，请仔细查看证书签发时间\033[0m \n"
 
 
echo "--------------------------------"
echo "etcd-healthcheck-client证书"
echo `openssl x509 -in /etc/kubernetes/pki/etcd/healthcheck-client.crt -noout -dates`
echo "--------------------------------"
echo "etcd-peer证书"
echo `openssl x509 -in /etc/kubernetes/pki/etcd/peer.crt -noout -dates`
echo "--------------------------------"
echo "etcd-server证书"
echo `openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -noout -dates`

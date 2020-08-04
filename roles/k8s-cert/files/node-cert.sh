#!/bin/bash
  
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
systemctl restart kubelet
  
  
  
  
echo -e "\033[5;33;40m slave单节点kubelet证书签发成功\033[0m \n"
  
echo -e "\033[5;33;40m 验证证书，请仔细查看证书签发时间\033[0m \n"
  
cat /etc/kubernetes/kubelet.conf |grep client-certificate-data |awk -F: '{print $2}' | awk '{print $1}' | base64 -d > a.crt
echo `openssl x509 -in a.crt -noout -dates`
rm -rf a.crt

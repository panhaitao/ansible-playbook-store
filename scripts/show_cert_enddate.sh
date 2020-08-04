#!/bin/sh

cd /etc/kubernetes/pki

for f in `find ./ | grep crt`
do
    enddate=`openssl x509 -in $f -noout -enddate`
    echo $f $enddate
done

#!/bin/bash
cat /etc/kubernetes/
for f in `find . | grep crt`;  do enddate=`openssl x509 -in $f -noout -enddate`; echo -e "$f    $enddate"; done

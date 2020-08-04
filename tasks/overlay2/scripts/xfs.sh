
#!/bin/bash

set -x
disk=/dev/vdb

mount | grep $disk
if [[ "$?" != "0" ]];then
dd if=/dev/zero of=$disk bs=4M count=1
parted --script $disk  mklabel gpt
parted --script $disk  mkpart primary 0 100%
parted --script $disk  name 1 docker          
mkfs.xfs -n ftype=1 ${disk}1 -f
fi

grep  "/var/lib/docker" /etc/fstab
if [[ "$?" != "0" ]];then
cat >> /etc/fstab <<EOF
${disk}1                                  /var/lib/docker                   xfs    defaults        1 1
EOF

fi

 mkdir -pv /var/lib/docker/ && mount -a

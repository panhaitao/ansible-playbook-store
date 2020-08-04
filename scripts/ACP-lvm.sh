#! /bin/bash
#ENV
DEVICE=$1

if [ ! $DEVICE ];then
lsblk
read -p "Please input you device: sdX, such as 'sdb' or 'sdc' , NOTE !! THIS IS DANGEROUS:"
DEVICE=$REPLY
fi

pvcreate /dev/$DEVICE
vgcreate docker /dev/$DEVICE
vgdisplay docker
lvcreate --wipesignatures y -n thinpool docker -l 90%VG
lvcreate --wipesignatures y -n thinpoolmeta docker -l 5%VG
lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta
mkdir -p /etc/lvm/profile/
cat <<EOF > /etc/lvm/profile/docker-thinpool.profile
activation {
thin_pool_autoextend_threshold=80
thin_pool_autoextend_percent=20
}
EOF
lvchange --metadataprofile docker-thinpool docker/thinpool
lvs -o+seg_monitor
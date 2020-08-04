pvcreate /dev/vdb
vgcreate docker /dev/vdb
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

      lvs -o+seg_monitor


exit

ansible nfs -m script -a alauda-k8s-check/scripts/check_system_stat.sh  | grep -v \"stdout\" &>> nfs_minitor_data.log

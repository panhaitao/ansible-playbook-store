#!/bin/bash

  TMP=/tmp/$$
  mkdir -pv ${TMP}
  mount {{ cluster.nfs_server }}:/{{ cluster.nfs_path }}/ ${TMP}
  mkdir -pv ${TMP}/{grafana,prometheus,alertmanager}
  rsync -av /var/lib/monitoring/grafana/     ${TMP}/grafana/ --delete
  rsync -av /var/lib/monitoring/prometheus/  ${TMP}/prometheus/ --delete 
  rsync -av /var/lib/monitoring/alertmanager ${TMP}/alertmanager --delete
  sync
  umount $TMP

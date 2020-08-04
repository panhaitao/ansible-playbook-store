#!/bin/bash
sed -i 's/^SELINUX=*$/SELINUX=disabled/g' /etc/selinux/config

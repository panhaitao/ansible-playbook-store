#!/bin/bash
sed -ri 's/.*swap.*/#&/' /etc/fstab
swapoff -a

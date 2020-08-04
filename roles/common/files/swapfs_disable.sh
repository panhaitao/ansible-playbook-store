#!/bin/sh
swapoff -a  && sed -i 's/.*swap.*/#&/' /etc/fstab

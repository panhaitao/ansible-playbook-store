#!/bin/bash
useradd zhs
echo "zhs:Zhs123456" | chpasswd
usermod zhs -G docker
echo "zhs  ALL=(ALL)       ALL" >> /etc/sudoers

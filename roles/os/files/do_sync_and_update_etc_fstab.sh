#!/bin/bash

mount | grep /buffer &>/dev/null
if [[  "$?" == "0" ]];then
    echo "/buffer already mounted"
else
    rsync -av /buffer /alauda/buffer
    rm -rvf /buffer
    mdir -pv /buffer
fi

cat /etc/fstab | grep /buffer &>/dev/null
if [[  "$?" == "0" ]];then
    echo "/buffer already in /etc/fstab"
else
    echo "/alauda/buffer/ /buffer none defaults,bind 0 0" >> /etc/fstab
fi

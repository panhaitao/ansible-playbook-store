#!/bin/bash

for img in  `cat images.list`
do
  docker pull $img
done

pri_repo=myhub.com

if [[ "$pri_repo" != "" ]];then

  for img in  `cat images.list`
  do
         docker tag $img ${pri_repo}/$img
         docker push ${pri_repo}/$img 
  done

fi

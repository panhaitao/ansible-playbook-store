#!/bin/bash

#########
# super_cp.sh srcdir destdir remove A目录中的文件列出来，如果在B目录中存在A中的文件，则删除重复
# super_cp.sh srcdir destdir rename A目录中的文件列出来，如果在B目录中存在A中的文件，不删除重复，遇到重名的就自动改名加前缀_
########

export srcdir=$1
export destdir=$2
export opt=$3

check_args() 
{
if [[ "$srcdir" == "" || "$destdir" == "" || "$opt" == "" ]];then
  echo "script args is empty!!!"
  echo "example:"
  echo "super_cp.sh srcdir destdir remove ## delete duplicate files "
  echo "super_cp.sh srcdir destdir rename ## rename duplicate files "
  exit 1
fi
}

check_args

tmpfile=/tmp/$$
> $tmpfile

awk 'BEGIN { cmd="cp -ri $srcdir/*  $destdir "; print "n" |cmd; }' &> $tmpfile

DUP_FILES=`cat $tmpfile | awk '{print $2}' | awk -F/ '{print $2}' | awk -F? '{print $1}'`

if [[ "$opt" == "remove" ]]; then
	for f in $DUP_FILES
	do
		rm -vf ${destdir}/$f
	done 
elif [[  "$opt" == "rename" ]]; then
	for f in $DUP_FILES
	do
		cp -v ${srcdir}/$f ${destdir}/_${f}
	done
fi

#!/bin/bash

### Check # of args
if [ $# -gt 1 ]; then
    echo "Error: Too many args." 
    echo "Usage: `basename $0` [string]"
    exit 1
elif [ $# -eq 1 ]; then
    if [ $1 = "-h" -o $1 = "-help" -o $1 = "--help" ]; then
	echo "Usage: `basename $0` [string]"
	exit 1
    fi
fi

### All or defined files
STRING=""
if [ $# -eq 1 ]; then
    STRING=$1
fi

### Get file list. Directory is skipped.
II=0
for I in $(ls $STRING*)
do
    if [ -f $I ]; then
	FILE[$II]=$I
	#echo "FILE[$II] = ${FILE[$II]}"

        SIZE=`ls -l ${FILE[$II]}`
        echo "size = ${SIZE[5]}"
	II=`expr $II + 1`
    fi
done

exit
nFILE=$II

### Get file size
II=0
while [ $II -lt $nFILE ]
do
    for I in $(ls
    md5sum ${FILE[$II]}
    II=`expr $II + 1`
done

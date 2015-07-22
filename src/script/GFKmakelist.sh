#!/bin/bash

##########################################
# Main process
##########################################

### Check # of args
if [ $# -ne 1 ]; then
    echo "Usage: `basename $0` directory_path"
    exit 1
fi

DIR=`(cd $1;pwd)`
#echo $DIR

### Input from ls
count=0
for I in $(ls $DIR/)
do
    if [ -d $DIR/$I ]; then
        INPUT[$count]="$DIR/$I"
        echo ${INPUT[$count]}
        count=`expr $count + 1`
    fi
done


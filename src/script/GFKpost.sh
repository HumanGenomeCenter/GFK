#!/bin/bash

# GFKDIR must be set
if [ "x$GFKDIR" = "x" ]; then
    echo "Error: GFKDIR is not set"
    exit 1
fi

##########################################
# Main process
##########################################

CMD=`basename $0`

### Check # of args
if [ $# -ne 1 ]; then
    echo "Error: no input files are indicated."
    echo "Usage: $CMD <GFKPostProcess.txt>"
    exit 1
fi

### Parameter file name
if [ ! -f $1 ]; then
    echo "$1 does not exist."
    exit
fi

### Input from the file
count=0
for I in $(cat $1)
do
    RANK[$count]=$I
    echo ${RANK[$count]}
    count=`expr $count + 1`
done

nSample=`expr $count - 1`
CAT=cat

echo "nSample = $nSample"

### Main process
I=0
PREFIX=GFKaligned
HEADER=$GFKDIR/bin/hg19.header
while [ $I -lt $nSample ]
do
    J=${RANK[$I]}
    II=`expr $I + 1`
    II=${RANK[$II]}
    echo "J = $J"
    echo "II = $II"
    FILE=${PREFIX}.$I
    echo $FILE

    $CAT $HEADER > $FILE

    while [ $J -lt $II ]
    do
        ### Merge files
        #if [ $J -eq ${RANK[$I]} ]; then
        #    $CAT GFOUTPUT.$J > $FILE
        #else
            $CAT GFKOUTPUT.$J >> $FILE
        #fi

        J=`expr $J + 1`
    done

    I=`expr $I + 1`
done

#!/bin/bash

readonly GFKDIR=..
readonly SAMTOOLS=../samtools

#########################################
# Subroutine
########################################
function sam2fastq(){
### Check # of args
#if [ $# -ne 4 ]; then
#  echo "Wrong Number of Arguments." 
#  echo "Usage: `basename $0` [inbam] [tmpbam prefix] [out fastq1] [out fastq2]"
#  exit 1
#fi

INBAM=$1
TMP_BAM_PREFIX=$2
FASTQ1=$3
FASTQ2=$4

echo "  Start bam sort."
$SAMTOOLS sort -m 8G -n $INBAM $TMP_BAM_PREFIX

if [ $? -ne 0 ]; then
  echo "Error: $SAMTOOLS sort -n $INBAM $TMP_BAM_PREFIX"
  exit $?
fi

echo "  Start bam to fastq conversion."
$SAMTOOLS view -F2304 ${TMP_BAM_PREFIX}.bam | perl ${GFKDIR}/sam2fastq.pl $FASTQ1 $FASTQ2

if [ $? -ne 0 ]; then
  echo "Error: $SAMTOOLS view -F2304 ${TMP_BAM_PREFIX}.bam | perl ${GFKDIR}/sam2fastq.pl $FASTQ1 $FASTQ2"
  exit $?
fi
}

##########################################
# Main process
##########################################

### Check # of args
if [ $# -ne 3 ]; then
    echo "Usage: `basename $0` bam_list_file start_ID end_ID"
    exit 1
fi

### Parameter file name
if [ ! -f $1 ]; then
    echo "$1 does not exist."
    exit
fi

date

### Input from the file
count=0
for I in $(cat $1)
do
    INPUT[$count]=$I
    #echo ${INPUT[$count]}
    count=`expr $count + 1`
done

nSample=$count
echo "nSample = $nSample"

SID=$2
EID=$3

### Create output directory
if [ ! -d Fastq ]; then
    mkdir Fastq
fi

### Main process
J=$SID
if [ $EID -gt $nSample ]; then
    echo "Warning: end_ID is modified to fit the input file list region($nSample)"
    EID=$nSample
fi

while [ $J -le $EID ]
do
    ### Get file name
    DIR=`basename ${INPUT[$J]}`
    FILE=`ls ${INPUT[$J]}/*.bam`
    TEMP=temp$J
    echo "FILE = $FILE"

    if [ ! -d Fastq/${DIR} ]; then
        mkdir Fastq/${DIR}
    fi

    sam2fastq $FILE $TEMP Fastq/${DIR}/sequence1.txt Fastq/${DIR}/sequence2.txt
    rm -f $TEMP.*
    J=`expr $J + 1`
done

echo "#####"
echo " BAM to Fastq conversion finished successfuly."
date
echo "#####"

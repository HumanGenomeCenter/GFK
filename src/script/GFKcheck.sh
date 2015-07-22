#!/bin/bash

# GFKDIR must be set
if [ "x$GFKDIR" = "x" ]; then
    echo "Error: GFKDIR is not set"
    exit 1
fi

HEADER=$GFKDIR/bin/hg19.header

### Check # of args
if [ $# -ne 1 ]; then
    echo "Checker for merged output files of GFK."
    echo "Usage: `basename $0` <sample_Fastq_dir_list_file>"
    exit 1
fi

### SampleID file name
if [ ! -f $1 ]; then
    echo "$1 does not exist."
    exit
fi

### Input from the file
nSample=`head -1 $1`
echo "nSample = $nSample"
II=0
for I in $(tail -$nSample $1)
do
    INPUT[$II]=$I
    #echo "INPUT[$II] = ${INPUT[$II]}"
    II=`expr $II + 1`
done
if [ $II -ne $nSample ]; then
    echo "Error: Get input file names from $1 failed in count."
    exit 1
fi


### Main process
echo "##### GFK checker result #####" > check.txt
echo -e "\t # of lines of input \t # of lines of output" > check.txt
PREFIX=GFKaligned
nError=0
II=0
while [ $II -lt $nSample ]
do
    echo "Checking $II sample ..."

    ### Get sequence file name
    #FILE=`ls ${INPUT[$II]}/*1.txt`
    DIR=${INPUT[${II}]}
    if [ -f ${DIR}/sequence1.txt ]; then
        FILE=${DIR}/sequence1.txt
    elif [ -f ${DIR}/*1.fastq ]; then
        FILE=`ls ${DIR}/*1.fastq`
	echo "Filename = $FILE"
    else
        echo "Sequence1 file does not exist."
        exit 1
    fi

    INPUT_LINES=`wc -l ${FILE} | awk '{print $1}'`
    OUTPUT_LINES=`wc -l ${PREFIX}.$II | awk '{print $1}'`

    echo -e "$II \t ${INPUT_LINES} \t ${OUTPUT_LINES}" >> check.txt

    JJ=`wc -l $HEADER | awk '{print $1}'`
    echo "# of header lines is $JJ"
    JJ=`expr ${OUTPUT_LINES} - $JJ`
    JJ=`expr $JJ \* 2`
    
    if [ ${INPUT_LINES} -ne $JJ ]; then
	ERROR[$nError]=${INPUT[$II]}
	nError=`expr $nError + 1`
    fi

    II=`expr $II + 1`
done

### Summary
echo "##### GFK result summary #####" >> check.txt
echo "Total sample : ${nSample}"
echo "Failed sample: ${nError}" >> check.txt
echo "">>check.txt
echo "----- Failed sample list -----" >> check.txt
II=0
while [ $II -lt $nError ]
do
    echo -e "$II \t ${ERROR[$II]}" >> check.txt
    II=`expr $II + 1`
done

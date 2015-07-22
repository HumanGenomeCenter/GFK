#!/bin/bash

CMD=`basename $0`
AVERAGE="../AverageBaseQuality.pl"

##########################################
# subroutine usage
##########################################
function usage()
{
    echo "Usage: $CMD dir_list_file [SID] [EID]"
    echo "  *ID: Start/end sample number."
    exit 1
}

##########################################
# Main process
##########################################
### Check # of args
if [ $# -lt 1 ]; then
    echo "Error: no input files are indicated."
    usage
elif [ $# -gt 3 ]; then
    echo "Error: Too many arguments are indicated."
    usage
elif [ $# -eq 2 ]; then
    echo "Error: SID and EID must be indicated simultaneously."
    usage
fi

### Parameter file name
if [ ! -f $1 ]; then
    echo "$1 does not exist."
    exit 1
fi

### Get IDs
if [ $# -eq 3 ]; then
    SID=$2
    EID=$3
    #echo "SID,EID = $SID $EID"
fi

if [ $SID -lt 0 -o $EID -lt $SID ]; then
    echo "Error: IDs are not appropriate."
    echo "SID, EID = $SID $EID"
    exit 1
fi


### Input from the file
count=0
for I in $(cat $1)
do
    INPUT[$count]=$I
    #echo ${INPUT[$count]}
    count=`expr $count + 1`
done

### Main loop
II=$SID
while [ $II -le $EID ]
do
    ### Get directory name
    DIR=${INPUT[$II]}
    if [ ! -e $DIR ];then
	echo "$DIR doesn't exist."
	exit 1
    fi

    ### Calculate base quality
    FILE=${DIR}/sequence1.txt
    AVG1=`perl ${AVERAGE} $FILE`
    #echo "AVG1= $AVG1"

    FILE=${DIR}/sequence2.txt
    AVG2=`perl ${AVERAGE} $FILE`
    #echo "AVG2= $AVG2"

    echo "${DIR}, ${AVG1}, ${AVG2}"
    II=`expr $II + 1`
done

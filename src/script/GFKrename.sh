#!/bin/bash

# GFKDIR must be set
if [ "x$GFKDIR" = "x" ]; then
    echo "Error: GFKDIR is not set"
    exit 1
fi

CMD=`basename $0`

##########################################
# subroutine usage
##########################################
function usage()
{
    echo "Usage: $CMD [-f] dir_list_file"
    echo "  Make symbolic link or rename output bam fime."
    echo "   -f: Force rename."
    echo "   -r: Renumber name."
    exit 1
}

##########################################
# Main process
##########################################
RENAME="FALSE"
RENUMBER="FALSE"

while getopts rh OPT
do
    case $OPT in
	"r" ) RENUMBER="TRUE" ;;
	"h" ) usage ;;
	 *  ) echo "Error: Invalid option ($OPT)" ; usage ;;
    esac
done
shift `expr $OPTIND - 1`


### Check # of args
if [ $# -lt 1 ]; then
    echo "Error: no input files are indicated."
    usage
elif [ $# -gt 2 ]; then
    echo "Error: Too many arguments are indicated."
    usage
fi

### Parameter file name
if [ ! -f $1 ]; then
    echo "$1 does not exist."
    exit 1
fi

### Get IDs
SID=0
EID=`head -1 $1`
#echo "SID,EID = $SID $EID"

if [ $EID -lt $SID ]; then
    echo "Error: IDs are not appropriate."
    echo "SID, EID = $SID $EID"
    exit 1
fi


### Input from the file
nSAMPLE=`head -1 $1`
echo "Number of samples = $nSAMPLE"

if [ $EID -ge $nSAMPLE ]; then
    echo "Warning: EID is set to the end of the region."
    EID=`expr $nSAMPLE - 1`
fi

count=0
    
for I in $(cat $1 | tail -$nSAMPLE)
do
    INPUT[$count]=`basename $I`
    echo ${INPUT[$count]}
    count=`expr $count + 1`
done

### Main loop
if [ $RENUMBER = "FALSE" ]; then

    II=$SID
    while [ $II -le $EID ]
    do
    ### Rename bam files
	PREFIX=GFKaligned
	POSTFIX=sorted.bam
	$SPLIT $FILE1 $nDiv $PREFIX1
	mv -f ${PREFIX}.${II}.${POSTFIX} ${INPUT[${II}]}.${II}.${POSTFIX}

	II=`expr $II + 1`
    done

else

    II=$SID
    while [ $II -le $EID ]
    do
    ### Rename bam files
	PREFIX=GFKaligned
	POSTFIX=sorted.bam
	$SPLIT $FILE1 $nDiv $PREFIX1
	mv -f  ${INPUT[${II}]}.${II}.${POSTFIX} ${PREFIX}.${II}.${POSTFIX}

	II=`expr $II + 1`
    done
fi

echo "Rename finished successfully!"

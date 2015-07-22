#!/bin/bash

# GFKDIR must be set
if [ "x$GFKDIR" = "x" ]; then
    echo "Error: GFKDIR is not set"
    exit 1
fi

CMD=`basename $0`
#SPLIT=split
SPLIT="perl ${GFKDIR}/bin/roundRobinSplit.pl"

##########################################
# subroutine usage
##########################################
function usage()
{
    echo "Usage: $CMD [-f] dir_list_file [SID] [EID]"
    echo "   -f: Execute finalize process."
    echo "  *ID: Start/end sample number."
    exit 1
}

##########################################
# subroutine getSuffix
##########################################
function getSuffix()
{
    #echo "RANK = $1"
    num=$1
    #num=`expr ${num} - 1`

    array=( a b c d e f g h i j k l m n o p q r s t u v w x y z )

    DIGIT1=`expr ${num} / 676`
    num1=`expr ${num} % 676`

    DIGIT2=`expr ${num1} / 26`
    DIGIT3=`expr ${num1} % 26`

    eval $2=${array[$DIGIT1]}${array[$DIGIT2]}${array[$DIGIT3]} 
}

##########################################
# Main process
##########################################
FINALIZE="FALSE"
NORMALSPLIT="FALSE"

while getopts fnh OPT
do
    case $OPT in
	"f" ) FINALIZE="TRUE" ;;
	"n" ) NORMALSPLIT="TRUE" ; echo "Normal split mode" ;;
	"h" ) usage ;;
	 *  ) echo "Error: Invalid option ($OPT)" ; usage ;;
    esac
done
shift `expr $OPTIND - 1`

if [ $FINALIZE = "FALSE" ]; then
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
    else
	SID=0
	EID=`head -1 $1`
        #echo "SID,EID = $SID $EID"
    fi

    if [ $SID -lt 0 -o $EID -lt $SID ]; then
	echo "Error: IDs are not appropriate."
	echo "SID, EID = $SID $EID"
	exit 1
    fi


    ### Input from the file
    nSAMPLE=`head -1 $1`
    SPLITLINES=`head -2 $1 | tail -1`
    echo "Number of samples = $nSAMPLE"
    echo "LINES for split = $SPLITLINES"

    if [ $EID -ge $nSAMPLE ]; then
	echo "Warning: EID is set to the end of the region."
	EID=`expr $nSAMPLE - 1`
    fi

    count=0
    
    for I in $(cat $1 | tail -$nSAMPLE)
    do
	INPUT[$count]=$I
	echo ${INPUT[$count]}
	count=`expr $count + 1`
    done


    ### Main loop
    II=$SID
    while [ $II -le $EID ]
    do
        ### Get directory name
	DIR=${INPUT[$II]}
	echo "Directory = $DIR"
	PREFIX1=GFKTEMP1.$II
	PREFIX2=GFKTEMP2.$II
	echo $DIR

	### Get sequence file name
	if [ -f ${DIR}/sequence1.txt ]; then
	    FILE1=${DIR}/sequence1.txt
	elif [ -f ${DIR}/*1.fastq ]; then
	    FILE1=`ls ${DIR}/*1.fastq`
	else
	    echo "Sequence1 file does not exist."
	    exit 1
	fi
	###
	if [ -f ${DIR}/sequence2.txt ]; then
	    FILE2=${DIR}/sequence2.txt
	elif [ -f ${DIR}/*2.fastq ]; then
	    FILE2=`ls ${DIR}/*2.fastq`
	else
	    echo "Sequence2 file does not exist."
	    exit 1
	fi
	#echo "FILE = $FILE1"
	#exit

        ### Calculate # of divisions
	#FILE=${DIR}/sequence1.txt
	nLINES=$(cat $FILE1 | wc -l)
	nDiv=`expr $nLINES / $SPLITLINES`
	echo "nDiv = $nDiv"
	if [ `expr $nLINES % $SPLITLINES` -ne 0 ]; then
	    nDiv=`expr $nDiv + 1`
	    echo "nDiv(modified) = $nDiv"
	fi

        ### Split sequence1
	#FILE=${DIR}/sequence1.txt
	if [ $NORMALSPLIT = "TRUE" ]; then
	    split -l $SPLITLINES -a 3 $FILE1 $PREFIX1.
	else
	    $SPLIT $FILE1 $nDiv $PREFIX1
	fi

        ### Split sequence2
	#FILE=${DIR}/sequence2.txt
	if [ $NORMALSPLIT = "TRUE" ]; then
	    split -l $SPLITLINES -a 3 $FILE2 $PREFIX2.
	else
	    $SPLIT $FILE2 $nDiv $PREFIX2
	fi

	II=`expr $II + 1`
    done

    echo "Fastq files are splitted successfully!"
else
    echo "Start finalize."
    ### Check # of args
    if [ $# -ne 1 ]; then
	echo "Error: no input files are indicated or too many args."
	usage
    fi
    
    ### Parameter file name
    if [ ! -f $1 ]; then
	echo "$1 does not exist."
	exit
    fi

    ### Input from the file
    nSAMPLE=`head -1 $1`
    echo "Number of samples = $nSAMPLE"

    ### Main loop
    II=0
    INDEX[0]=0
    while [ $II -lt $nSAMPLE ]
    do
        ### Get directory name
	PREFIX1=GFKTEMP1.$II
	PREFIX2=GFKTEMP2.$II

        ### Get number of files
	nDiv=`ls -l ${PREFIX1}.* | wc -l`
	echo "nDiv = $nDiv"

        ### Rename sequence1
	PREFIX3=GFKINPUT1
	JJ=0
	while [ $JJ -lt $nDiv ]
	do
	    RANK=`expr ${INDEX[$II]} + $JJ`
	    getSuffix $JJ SUFFIX
	    echo ${PREFIX1}.$SUFFIX
	    mv -f ${PREFIX1}.$SUFFIX ${PREFIX3}.$RANK

	    JJ=`expr $JJ + 1`
	done

        ### Rename sequence2
	PREFIX3=GFKINPUT2
	JJ=0
	while [ $JJ -lt $nDiv ]
	do
	    RANK=`expr ${INDEX[$II]} + $JJ`
	    getSuffix $JJ SUFFIX
	    echo ${PREFIX2}.$SUFFIX
	    mv -f ${PREFIX2}.$SUFFIX ${PREFIX3}.$RANK

	    JJ=`expr $JJ + 1`
	done

	INDEX[`expr $II + 1`]=`expr ${INDEX[$II]} + $nDiv`
	II=`expr $II + 1`
    done

    ### Output relationship between sample and rank number region
    echo -e "${INDEX[0]}" > GFKPostProcess.txt
    I=1
    while [ $I -le $nSAMPLE ]
    do
	echo -e "${INDEX[$I]}" >> GFKPostProcess.txt
	I=`expr $I + 1`
    done
    
fi

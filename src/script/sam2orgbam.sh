#! /bin/bash
#$ -S /bin/bash
#$ -cwd
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

PICARD_PATH=..
SAMTOOLS=../samtools

### Check # of args
if [ $# -lt 1 -o $# -gt 3 ]; then
    echo "Usage: `basename $0` Start_ID End_ID [Prefix]"
    echo "   Start_ID: Start file number"
    echo "     End_ID: End file number"
    echo "     Prefix: Input file prefix (optional)"
    exit 1
fi

readonly SID=$1
readonly EID=$2

if [ $# -eq 3 ]; then
    PREFIX1=$3
else
    PREFIX1=GFKaligned
fi

LOGFILE="${SID}-${EID}.log"

readonly RECORDS_IN_RAM=5000000

echo "sam2orgbam start at `date`" > $LOGFILE
echo "" >> $LOGFILE
echo "-------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE

II=$SID
while [ $II -le $EID ]
do
    PREFIX2=${PREFIX1}.${II}
    echo "${PREFIX2} process start: `date`" >> $LOGFILE

    echo "   sam to bam: `date`" >> $LOGFILE
    $SAMTOOLS view -Sb ${PREFIX2} > ${PREFIX2}.bam

    echo "   sort sam: `date`" >> $LOGFILE
    #$SAMTOOLS sort -m 64G  ${PREFIX2}.bam ${PREFIX2}.sorted
    #$SAMTOOLS sort -m 32G  ${PREFIX2}.bam ${PREFIX2}.sorted ### Memory absence
    $SAMTOOLS sort -m 8G  ${PREFIX2}.bam ${PREFIX2}.sorted ### Memory absence
    rm -f ${PREFIX2}.bam

    II=`expr $II + 1`
done

echo "" >> $LOGFILE
echo "-------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE
echo "sam2orgbam finished at `date`" >> $LOGFILE

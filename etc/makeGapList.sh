#! /bin/bash
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

INTERVAL=$1
LIST=intervalList.txt

nFILES=`ls ${INTERVAL} | wc -l`
echo "Number of interval_list files is $nFILES"

rm -f $LIST
NUM=1
while [ $NUM -le $nFILES ];
do
    echo "$NUM file processing..."
    REGION_A=`head -n1 ${INTERVAL}/${NUM}.interval_list | awk '{split($0, ARRAY, "-"); print ARRAY[1]}'`
    REGION_B=`tail -n1 ${INTERVAL}/${NUM}.interval_list | awk '{split($0, ARRAY, "-"); print ARRAY[2]}'`
    REGION="${REGION_A}-${REGION_B}"
    echo ${REGION} >> $LIST
    NUM=`expr $NUM + 1`
done

echo "Finished."
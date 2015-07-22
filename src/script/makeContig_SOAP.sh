#! /bin/bash
#$ -S /bin/bash
#$ -cwd
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

GFKDIR=$1
SHAREDDIR=$2
rank=$3
OMP_FLAG=$4

# process the above data and complete the table for relationships between combinations of junctions and their sequences
#echo "perl ../procComb2seq.pl ./comb2seq.tmp.txt > ./comb2seq.txt"
echo "perl ${GFKDIR}/procComb2seq.pl ./comb2seq.tmp.${rank}.txt > ./comb2seq.${rank}.txt" >&2
perl ${GFKDIR}/procComb2seq.pl ${SHAREDDIR}/comb2seq.tmp.${rank}.txt > ./comb2seq.${rank}.txt


TMPCONTIGDIR=./tmp_contig/${rank}
if [ ! -d ${TMPCONTIGDIR} ]; then
    mkdir -p ${TMPCONTIGDIR}
fi

echo -n > ./candFusionContig.${rank}.fa
echo -n > ./candFusionPairNum.${rank}.txt

num=0
while read LINE; do 

  comb=`echo ${LINE} | cut -d ' ' -f 1`
  segseq=`echo ${LINE} | cut -d ' ' -f 2`
  ids=( `echo ${LINE} | cut -d ' ' -f 3 | tr -s ',' ' '` )
  seqs=( `echo ${LINE} | cut -d ' ' -f 4 | tr -s ',' ' '` )

  # make the fasta file for each junction pair 
  echo ${comb}
  echo -n > ${TMPCONTIGDIR}/candSeq_${num}.tmp.fa
  for (( i = 0; i < ${#seqs[@]}; i++ ))
  {
    echo '>'${ids[$i]}  >> ${TMPCONTIGDIR}/candSeq_${num}.tmp.fa 
    echo "${seqs[$i]}" >> ${TMPCONTIGDIR}/candSeq_${num}.tmp.fa
  }

  # if the number of reads exceeds 1000, then discard randomly to reach 1000 reads
  echo "perl ../randFasta.pl ./tmp_contig/candSeq_${num}.tmp.fa 1000 > ./tmp_contig/candSeq_${num}.fa" >&2
  perl ${GFKDIR}/randFasta.pl ${TMPCONTIGDIR}/candSeq_${num}.tmp.fa 1000 > ${TMPCONTIGDIR}/candSeq_${num}.fa

  # make the constraint file for the paired end sequences (maybe the constraint information is not reflected in CAP3 assembly?)
  echo "perl ../my_formcon.pl ./tmp_contig/candSeq_${num}.fa > ./tmp_contig/candSeq_${num}.fa.con" >&2
  perl ${GFKDIR}/my_formcon.pl ${TMPCONTIGDIR}/candSeq_${num}.fa > ${TMPCONTIGDIR}/candSeq_${num}.fa.con


  # assemble the sequences via CAP3
  #echo "${CAP3_PATH}/cap3 ./tmp_contig/candSeq_${num}.fa -p 66 -o 16 > ./tmp_contig/candSeq_${num}.contig" >&
  echo "${GFKDIR}/createSOAPconfig.sh ${TMPCONTIGDIR}/SOAP_config.txt ${TMPCONTIGDIR}/candSeq_${num}.fa" >&2
  ${GFKDIR}/createSOAPconfig.sh ${TMPCONTIGDIR}/SOAP_config.txt ${TMPCONTIGDIR}/candSeq_${num}.fa
  #../SOAPdenovo-Trans-31mer all -s ${TMPCONTIGDIR}/SOAP_config.txt -o ${TMPCONTIGDIR}/candSeq_${num}.contig
  ${GFKDIR}/SOAPdenovo-Trans-31mer pregraph -s ${TMPCONTIGDIR}/SOAP_config.txt -K 13 -p 1 -o ${TMPCONTIGDIR}/candSeq_${num}
  ${GFKDIR}/SOAPdenovo-Trans-31mer contig -g ${TMPCONTIGDIR}/candSeq_${num}

  FILE_SIZE=`cat ${TMPCONTIGDIR}/candSeq_${num}.contig | wc -c`

  #if [ -s ${TMPCONTIGDIR}/candSeq_${num}.contig ]; then
  if [ $FILE_SIZE -gt 0 ]; then
      echo "Contig file size = $FILE_SIZE ($num)" 1>&2
      # alignment the junction sequence to the set of contigs generated via CAP3 and select the best contig
      echo '>'query > ${TMPCONTIGDIR}/query_${num}.fa
      echo ${segseq} >> ${TMPCONTIGDIR}/query_${num}.fa
      echo "../fasta36 -d 1 -m 8 ./tmp_contig/query_${num}.fa ./tmp_contig/candSeq_${num}.fa.cap.contigs > ./tmp_contig/candSeq_${num}.contigs.fastaTabular" >&2
      ${GFKDIR}/fasta36 -d 1 -m 8 ${TMPCONTIGDIR}/query_${num}.fa ${TMPCONTIGDIR}/candSeq_${num}.contig > ${TMPCONTIGDIR}/candSeq_${num}.contigs.fastaTabular


      echo "perl ../selectContig.pl ./tmp_contig/candSeq_${num}.contigs.fastaTabular ./tmp_contig/candSeq_${num}.fa.cap.contigs > ./tmp_contig/candSeq_${num}.contigs.selected" >&2
      perl ${GFKDIR}/selectContig.pl ${TMPCONTIGDIR}/candSeq_${num}.contigs.fastaTabular ${TMPCONTIGDIR}/candSeq_${num}.contig > ${TMPCONTIGDIR}/candSeq_${num}.contigs.selected
      if [ $? -ne 0 ]; then
	  echo "Error at selectContig.pl, NUM=${num}"
	  exit
      fi

      # This step is skipped because SOAP outputs are already forward-reverse compliment.
      # count the number of read pairs aligned properly to the selected contig
      #echo "perl ../procAce.pl ./tmp_contig/candSeq_${num}.fa.cap.ace ./tmp_contig/candSeq_${num}.contigs.selected | sort -k 2 -n  > ./tmp_contig/candSeq_${num}.consensusPair"
      #perl ../procAce.pl ${TMPCONTIGDIR}/candSeq_${num}.fa.cap.ace ${TMPCONTIGDIR}/candSeq_${num}.contigs.selected | sort -k 2 -n  > ${TMPCONTIGDIR}/candSeq_${num}.consensusPair

      # get the contig sequence and add it to the candFusionContig.fa file
      echo ">"${comb} >> ./candFusionContig.${rank}.fa
      echo "perl ../extractContigSeq.pl ./tmp_contig/candSeq_${num}.fa.cap.contigs ./tmp_contig/candSeq_${num}.contigs.selected >> ./candFusionContig.fa" >&2
      perl ${GFKDIR}/extractContigSeq.pl ${TMPCONTIGDIR}/candSeq_${num}.contig ${TMPCONTIGDIR}/candSeq_${num}.contigs.selected >> ./candFusionContig.${rank}.fa
      if [ $? -ne 0 ]; then
	  echo "Error at extractContigSeq.pl, NUM=${num}"
	  exit
      fi


      # write the number of properly alinged read pairs to the candFusionPairNum.txt file
      ## right_pair_num=`awk 'END{print NR}' ${TMPCONTIGDIR}/candSeq_${num}.consensusPair`
      # right_pair_num=`wc -l ./tmp_contig/candSeq_${num}.consensusPair | cut -d " " -f 1`
      #echo "echo -e "${comb}\t${right_pair_num}" >> ./candFusionPairNum.txt"
      ## echo -e "${comb}\t${right_pair_num}" >> ./candFusionPairNum.${rank}.txt

  fi

  num=`expr ${num} + 1`

done < ./comb2seq.${rank}.txt



echo "perl ../addContig.pl ${SHAREDDIR}/juncList_anno4.txt ./candFusionContig.fa > ./juncList_anno5.txt" >&2
perl ${GFKDIR}/addContig.pl ${SHAREDDIR}/juncList_anno4.${rank}.txt ./candFusionContig.${rank}.fa > ./juncList_anno5.${rank}.txt


# aling the contigs split by the junction points to the genome including alternative assembly and filter if they are alinged to multiple locations
echo "perl ../makeJuncSeqPairFa.pl ./juncList_anno5.txt > ./juncContig.fa" >&2
perl ${GFKDIR}/makeJuncSeqPairFa.pl ./juncList_anno5.${rank}.txt > ./juncContig.${rank}.fa


echo "${GFKDIR}/blat -stepSize=5 -repMatch=2253 -ooc=${GFKDIR}/11.ooc ${GFKDIR}/hg19.all.2bit ./juncContig.${rank}.fa ./juncContig.${rank}.psl" >&2
${GFKDIR}/blat -stepSize=5 -repMatch=2253 -ooc=${GFKDIR}/11.ooc ${GFKDIR}/hg19.all.2bit ./juncContig.${rank}.fa ./juncContig.${rank}.psl
if [ $OMP_FLAG -eq 1 ]; then
    cat ./juncContig.${rank}.psl.* > ./juncContig.${rank}.psl
    rm -f ./juncContig.${rank}.psl.*
fi

echo "perl ../filterByJunction.pl ./juncContig.psl > ./juncContig.filter.txt" >&2
perl ${GFKDIR}/filterByJunction.pl ./juncContig.${rank}.psl > ./juncContig.filter.${rank}.txt


echo "perl ../addFilterByJunction.pl ./juncList_anno5.txt ./juncContig.filter.txt > ./juncList_anno6.txt" >&2
perl ${GFKDIR}/addFilterByJunction.pl ./juncList_anno5.${rank}.txt ./juncContig.filter.${rank}.txt > ./juncList_anno6.${rank}.txt


# echo "join -1 1 -2 1 -t'	'  ./juncList_anno6.txt ./candFusionPairNum.txt > ./juncList_anno7.txt"
# join -1 1 -2 1 -t'	'  ./juncList_anno6.txt ./candFusionPairNum.txt > ./juncList_anno7.txt

echo "perl ../joinFile.pl ./juncList_anno6.txt ./candFusionPairNum.txt > ./juncList_anno7.txt" >&2
perl ${GFKDIR}/joinFile.pl ./juncList_anno6.${rank}.txt > ./juncList_anno7.${rank}.txt


echo "perl ../addHeader.pl ./juncList_anno7.txt > ./${TAG}.fusion.txt" >&2
perl ${GFKDIR}/addHeader.pl ./juncList_anno7.${rank}.txt > ./fusion.${rank}.txt
